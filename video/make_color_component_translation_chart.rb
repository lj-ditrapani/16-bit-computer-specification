# Displays the conversion of a color component from 3 bits to 8 bits
#                                          and from 2 bits to 8 bits.
print "\n3-bit to 8-bit color component conversion\n\n"
puts "  3-bit  |     8-bit        "
puts "dec bin  |   bin     dec hex"
puts "-" * 30
0.upto(7).each do |n|
  n_s = n.to_s.rjust(2, " ")
  b3 = n.to_s(2).rjust(3, '0')
  n2 = (n << 5) | (n << 2) | (n >> 1)
  b8 = n2.to_s(2).rjust(8, '0')
  n2_s = n2.to_s.rjust(3, " ")
  n2_s_hex = n2.to_s(16).rjust(2, '0')
  print " #{n_s} #{b3}  |  #{b8} #{n2_s}  #{n2_s_hex}\n"
end
puts ""
print "\n2-bit to 8-bit color component conversion\n\n"
puts "  2-bit |     8-bit        "
puts "dec bin |   bin     dec hex"
puts "-" * 30
0.upto(3).each do |n|
  n_s = n.to_s.rjust(2, " ")
  b3 = n.to_s(2).rjust(2, '0')
  n2 = (n << 6) | (n << 4) | (n << 2) | n
  b8 = n2.to_s(2).rjust(8, '0')
  n2_s = n2.to_s.rjust(3, " ")
  n2_s_hex = n2.to_s(16).rjust(2, '0')
  print " #{n_s} #{b3}  |  #{b8} #{n2_s}  #{n2_s_hex}\n"
end
puts ""
