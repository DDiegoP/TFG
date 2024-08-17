# SimpleOSC for Godot 4.0 alpha3 , version 0.1
# Copyright (c) 2022 Lyuma <xn.lyuma@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

extends RefCounted
## TODO: document??

var udp_peer: PacketPeerUDP
var _warned_types: Dictionary = {}
var received_timetag: Vector2i = Vector2i(0,0)
var DEBUG_BYTES: bool = false

### Parsing / decoding functions:
func parse_type(type_tag: String, stream_peer_buffer: StreamPeerBuffer) -> Variant:
	match type_tag:
		'T':
			return true
		'F':
			return false
		'N':
			return null
		'I':
			return Signal()
		'i':
			assert(stream_peer_buffer.get_available_bytes() >= 4)
			return stream_peer_buffer.get_32()
		'f':
			assert(stream_peer_buffer.get_available_bytes() >= 4)
			return stream_peer_buffer.get_float()
		't':
			assert(stream_peer_buffer.get_available_bytes() >= 8)
			var secs: int = stream_peer_buffer.get_32()
			var nanosecs: int = stream_peer_buffer.get_32()
			return Vector2i(secs, nanosecs)
		's':
			var buflen = stream_peer_buffer.get_available_bytes()
			var s: String = stream_peer_buffer.get_string(buflen)
			stream_peer_buffer.seek((stream_peer_buffer.get_position() - buflen + len(s) + 4) & ~3)
			return s
		'b':
			assert(stream_peer_buffer.get_available_bytes() >= 4)
			var mylen: int = stream_peer_buffer.get_u32()
			var ret: PackedByteArray = stream_peer_buffer.get_data(mylen)[1] # [0] is an error code. we ignore it.
			stream_peer_buffer.seek((stream_peer_buffer.get_position() + 3) & ~3)
			return ret
		# Non-standard types:
		'r':
			assert(stream_peer_buffer.get_available_bytes() >= 4)
			var r: float = stream_peer_buffer.get_u8() / 255.0
			var g: float = stream_peer_buffer.get_u8() / 255.0
			var b: float = stream_peer_buffer.get_u8() / 255.0
			var a: float = stream_peer_buffer.get_u8() / 255.0
			return Color(r, g, b, a)
		'h':
			assert(stream_peer_buffer.get_available_bytes() >= 8)
			return PackedInt64Array([stream_peer_buffer.get_64()])
		'd':
			assert(stream_peer_buffer.get_available_bytes() >= 8)
			return PackedFloat64Array([stream_peer_buffer.get_double()])
		'c':
			assert(stream_peer_buffer.get_available_bytes() >= 4)
			# decode with .to_byte_array().get_string_from_utf32()
			return PackedInt32Array([stream_peer_buffer.get_32()])
		_:
			if not _warned_types.has(type_tag):
				push_warning("Unsupprorted type tag received: " + str(type_tag))
				_warned_types[type_tag] = true
	return null

func serialize_type(value: Variant, type_tag: String, stream_peer_buffer: StreamPeerBuffer) -> Variant:
	#print("Serialize " + str(typeof(value)) + " " + str(value) + " as " + type_tag)
	match type_tag:
		'T', 'F', 'N', 'I':
			return
		'i':
			stream_peer_buffer.put_32(value)
		'f':
			stream_peer_buffer.put_float(value)
		't':
			var v2 = value as Vector2i
			stream_peer_buffer.put_32(v2.x) # seconds
			stream_peer_buffer.put_32(v2.y) # nanoseconds
		's':
			var pba = (value as String).to_ascii_buffer()
			stream_peer_buffer.put_data(pba)
			# include nul terminator:
			for i in range(((len(pba) + 4) & ~3) - len(pba)):
				stream_peer_buffer.put_u8(0)
		'b':
			var pba = value as PackedByteArray
			stream_peer_buffer.put_u32(len(pba))
			stream_peer_buffer.put_data(pba)
			for i in range(((len(pba) + 3) & ~3) - len(pba)):
				stream_peer_buffer.put_u8(0)
		# Non-standard types:
		'r':
			var col = value as Color
			stream_peer_buffer.put_u8(col.r8)
			stream_peer_buffer.put_u8(col.g8)
			stream_peer_buffer.put_u8(col.b8)
			stream_peer_buffer.put_u8(col.a8)
		'h':
			var arr = value as PackedInt64Array
			assert(len(arr) == 1)
			stream_peer_buffer.put_u64(arr[0])
		'd':
			var arr = value as PackedFloat64Array
			assert(len(arr) == 1)
			stream_peer_buffer.put_double(arr[0])
		'c':
			# Encode with PackedInt32Array([s.to_utf32_buffer().decode_u32(0)])
			var arr = value as PackedInt32Array
			assert(len(arr) == 1)
			stream_peer_buffer.put_u32(arr[0])
		_:
			push_error("Unexpected type tag to serialize: " + str(type_tag))
	return null

func decode_osc_into(packet_array: Array[Array], stream_peer_buffer: StreamPeerBuffer):
	# NOTE: Make sure the stream_peer_buffer is in big_endian mode.
	stream_peer_buffer.big_endian = true
	var buflen = stream_peer_buffer.get_available_bytes() # get_string() is ASCII
	var path: String =  stream_peer_buffer.get_string(buflen)
	stream_peer_buffer.seek((stream_peer_buffer.get_position() - buflen + len(path) + 4) & ~3)
	if stream_peer_buffer.get_position() == 8 and path == "#bundle":
		var timetag_secs: int = stream_peer_buffer.get_u32()
		var timetag_nanos: int = stream_peer_buffer.get_u32()
		var timetag = Vector2i(timetag_secs, timetag_nanos)
		while stream_peer_buffer.get_available_bytes() > 4:
			var msglen: int = stream_peer_buffer.get_u32()
			var end_msg = stream_peer_buffer.get_position() + msglen
			decode_osc_into(packet_array, stream_peer_buffer)
			if stream_peer_buffer.get_position() > end_msg:
				if not _warned_types.has("bundle_length"):
					push_warning("Read too much in nested message")
					_warned_types["bundle_length"] = true
			stream_peer_buffer.seek(end_msg)
		self.received_timetag = timetag
		return
	var typetag_comma = stream_peer_buffer.get_u8()
	if typetag_comma != 44: # ',' ascii
		push_error("Invalid type tag received: " + str(typetag_comma) + " for path " + path)
		return
	buflen = stream_peer_buffer.get_available_bytes()
	var typetag = stream_peer_buffer.get_string(stream_peer_buffer.get_available_bytes())
	stream_peer_buffer.seek((stream_peer_buffer.get_position() - buflen + len(typetag) + 4) & ~3)
	var arguments: Array = [path]
	var nested: Array = [arguments]
	for ch in typetag:
		if ch == '[':
			var new_arr = [].duplicate()
			nested[-1].append(new_arr)
			nested.append(new_arr)
		elif ch == ']':
			nested.pop_back()
		else:
			nested[-1].append(parse_type(ch, stream_peer_buffer))
	packet_array.append(arguments)

### Encoding/sending functions:
func generate_osc_type_tag(packet: Array, skip_first: bool=true):
	var i: int = 0
	var type_tag = ""
	for p in packet:
		i += 1
		if skip_first and i == 1:
			type_tag += ","
			continue
		match typeof(p):
			TYPE_ARRAY:
				type_tag += "["
				type_tag += generate_osc_type_tag(p, false)
				type_tag += "]"
			TYPE_FLOAT:
				type_tag += "f"
			TYPE_INT:
				type_tag += "i"
			TYPE_COLOR: # with one element
				type_tag += "r"
			TYPE_BOOL: # with one element
				type_tag += "T" if p else "F"
			TYPE_NIL: # with one element
				type_tag += "N"
			TYPE_OBJECT: # with one element
				if p:
					push_error("Invalid object type")
				else:
					type_tag += "N"
			TYPE_SIGNAL:
				type_tag += "I"
			TYPE_STRING:
				type_tag += "s"
			TYPE_PACKED_BYTE_ARRAY:
				type_tag += "b"
			TYPE_VECTOR2I: # with one element
				type_tag += "t" # time tag = secs, nanosecs
			# Extra type tags:
			TYPE_PACKED_FLOAT64_ARRAY: # with one element
				type_tag += "d" # double
			TYPE_PACKED_INT64_ARRAY: # with one element
				type_tag += "h" # int64
			TYPE_PACKED_INT32_ARRAY: # with one element
				type_tag += "c" # single character
			_:
				push_error("Invalid type " + str(type_tag))
	return type_tag

### IMPORTANT! Make sure to stream_peer_buffer.resize(stream_peer_buffer.get_position()) after calling
### In order to clear out the extra uninitialized memory.
func encode_osc(stream_peer_buffer: StreamPeerBuffer, packet: Array, type_tag_override: String=""):
	# NOTE: Make sure the stream_peer_buffer is in big_endian mode.
	stream_peer_buffer.big_endian = true
	assert(typeof(packet[0]) == TYPE_STRING)
	var path: String = packet[0]
	var type_tag: String = self.generate_osc_type_tag(packet, true) if type_tag_override.is_empty() else type_tag_override
	var pba = path.to_ascii_buffer()
	stream_peer_buffer.put_data(pba)
	# include nul terminator:
	for i in range(((len(pba) + 4) & ~3) - len(pba)):
		stream_peer_buffer.put_u8(0)
	pba = type_tag.to_ascii_buffer()
	stream_peer_buffer.put_data(pba)
	# include nul terminator:
	for i in range(((len(pba) + 4) & ~3) - len(pba)):
		stream_peer_buffer.put_u8(0)
	var nested: Array = [packet]
	var nested_idx: Array = [1]
	for ch in type_tag:
		if ch == ',':
			continue
		if ch == '[':
			var new_arr = nested[-1][nested_idx[-1]] as Array
			# nested[-1].append(new_arr)
			nested.append(new_arr)
			nested_idx[-1] += 1
			nested_idx.append(0)
		elif ch == ']':
			nested.pop_back()
			nested_idx.pop_back()
		else:
			serialize_type(nested[-1][nested_idx[-1]], ch, stream_peer_buffer)
			nested_idx[-1] += 1

### IMPORTANT! Make sure to stream_peer_buffer.resize(stream_peer_buffer.get_position()) after calling
### In order to clear out the extra uninitialized memory.
func encode_osc_bundle(stream_peer_buffer: StreamPeerBuffer, timetag: Vector2i, packets: Array[Array]):
	# NOTE: Make sure the stream_peer_buffer is in big_endian mode.
	stream_peer_buffer.big_endian = true
	stream_peer_buffer.put_data("#bundle".to_ascii_buffer())
	stream_peer_buffer.put_u8(0)
	stream_peer_buffer.put_32(timetag.x)
	stream_peer_buffer.put_32(timetag.y)
	for p in packets:
		var offset: int = stream_peer_buffer.get_position()
		stream_peer_buffer.put_u32(0)
		encode_osc(stream_peer_buffer, p)
		var end_offset: int = stream_peer_buffer.get_position()
		stream_peer_buffer.seek(offset)
		stream_peer_buffer.put_u32(end_offset - offset - 4)
		stream_peer_buffer.seek(end_offset)

### Networking functions:
func udp_bind(udp_port: int=0):
	if udp_peer != null:
		udp_peer.close()
	udp_peer = PacketPeerUDP.new()
	udp_peer.bind(udp_port)

func udp_get_local_port():
	return udp_peer.get_local_port() # Useful if doing udp_bind(0)

# Nuanced difference between connect and set_dest_address
# I think either works, but they are both here anyway.
func udp_connect_to_host(host: String, port: int):
	if udp_peer == null:
		udp_peer = PacketPeerUDP.new()
	udp_peer.connect_to_host(host, port)

func udp_set_dest_address(host: String, port: int):
	if udp_peer == null:
		udp_peer = PacketPeerUDP.new()
	udp_peer.set_dest_address(host, port)

func send_osc_packet(packet: Array):
	var arr = PackedByteArray()
	arr.resize(8192)
	var stream_peer_buffer = StreamPeerBuffer.new()
	stream_peer_buffer.clear()
	stream_peer_buffer.data_array = arr
	stream_peer_buffer.big_endian = true
	encode_osc(stream_peer_buffer, packet)
	stream_peer_buffer.resize(stream_peer_buffer.get_position())
	udp_peer.put_packet(stream_peer_buffer.data_array)

func send_osc_bundle(timetag: Vector2i, packets: Array[Array]):
	var arr = PackedByteArray()
	arr.resize(8192)
	var stream_peer_buffer = StreamPeerBuffer.new()
	stream_peer_buffer.clear()
	stream_peer_buffer.data_array = arr
	stream_peer_buffer.big_endian = true
	# TODO: fragmentation
	encode_osc_bundle(stream_peer_buffer, timetag, packets)
	stream_peer_buffer.resize(stream_peer_buffer.get_position())
	if DEBUG_BYTES:
		print("Sending " + str(stream_peer_buffer.data_array))
	udp_peer.put_packet(stream_peer_buffer.data_array)

func get_bundle_timetag() -> Vector2i:
	return self.received_timetag

func read_incoming_osc() -> Array[Array]:
	var packets: Array[Array] = []
	var num_packets: int = udp_peer.get_available_packet_count() # actually reads data.
	var stream_peer_buffer = StreamPeerBuffer.new()
	for i in range(num_packets):
		var packet = udp_peer.get_packet()
		stream_peer_buffer.clear()
		stream_peer_buffer.data_array = packet
		stream_peer_buffer.big_endian = true
		stream_peer_buffer.seek(0)
		if DEBUG_BYTES:
			print("Decoding " + str(stream_peer_buffer.data_array))
		decode_osc_into(packets, stream_peer_buffer)
	return packets
