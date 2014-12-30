
ruby $WORKING_DIR/main.rb

##file main.rb <<EOF

while line = STDIN.gets
  line.force_encoding("%ENCODING_FROM").encode!("%ENCODING_TO", :invalid => :replace, :undef => :replace)
  puts(line)
end

EOF

