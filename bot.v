module ascii_robot

import rand

pub fn random_robot() string {
	out := generate(random_id()) or { '' }
	return out
}

pub fn random_id() string {
	mut out := ""
	for i := 0; i < 5; i++ {
		out += rand.intn(16).hex() // 16 because hex
	}
	return out
}

pub fn must_generate(id string) string {
	out := generate(id) or { panic(err) }
 	return out
}

pub fn generate(id string) ?string {
	if id.len != 5 {
		return error('id length must be equal to 5')
	}
	str := string(id.bytes().map(hex_only(it)))

	if str.len != 5 {
		return error('id must be 5 hexadecimal characters [0-9a-f]')
	}

	mut out := ""

	// generate body
	top, _, _ := split(templates[str[0..1]])
	_, center, _ := split(templates[str[1..2]])
	_, _, bottom := split(templates[str[2..3]])
	out += top
	out += center
	out += bottom

	// replace eyes
	out = replace(out, eyes[str[3..4]], 6, 1)

	// replace mouth
	out = replace(out, mouths[str[4..5]], 7, 2)

	return out
}

fn hex_only(r byte) byte {
	match r {
	 `0`, `1`, `2`, `3`, `4`, `5`, `6`, `7`, `8`, `9` {
		 return r
	 }

	`a`, `b`, `c`, `d`, `e`, `f` {
		return r
	}
	else {
		return -1
	}

	}
}

// split splits template into top, center and bottom parts
fn split(template string) (string, string, string) {
	s := template.split(r"\n")
	top := s[0..3].join("\n") + "\n"
	center := s[3..5].join("\n") + "\n"
	bottom := s[5..7].join("\n")
	return top, center, bottom
}

// replace replaces body parts at position x,y
fn replace(body string, replace string, x, y int) string {
	mut lines := body.split("\n")
	lines[y] = lines[y][0..x] + replace + lines[y][x+replace.len..]
	return lines.join("\n")
}
