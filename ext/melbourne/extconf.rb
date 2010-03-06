require 'mkmf'

$CFLAGS += " -ggdb3"

# Courtesy of EventMachine. Thank you EventMachine and tmm1 !

def check_libs(libs = [], fatal = false)
  libs.all? { |lib| have_library(lib) || (abort("could not find library: #{lib}") if fatal) }
end
 
def check_heads(heads = [], fatal = false)
  heads.all? { |head| have_header(head) || (abort("could not find header: #{head}") if fatal)}
end
 
def add_define(name)
  $defs.push("-D#{name}")
end

case RUBY_PLATFORM
  when /mswin32/, /mingw32/, /bccwin32/
    check_heads(%w[windows.h winsock.h], true)
    check_libs(%w[kernel32 rpcrt4 gdi32], true)

    if GNU_CHAIN
      CONFIG['LDSHARED'] = "$(CXX) -shared -lstdc++"
    else
      $defs.push "-EHs"
      $defs.push "-GR"
    end

  when /solaris/
    add_define 'OS_SOLARIS8'

    if CONFIG['CC'] == 'cc' and `cc -flags 2>&1` =~ /Sun/ # detect SUNWspro compiler
      # SUN CHAIN
      add_define 'CC_SUNWspro'
      $preload = ["\nCXX = CC"] # hack a CXX= line into the makefile
      $CFLAGS = CONFIG['CFLAGS'] = "-KPIC"
      CONFIG['CCDLFLAGS'] = "-KPIC"
      CONFIG['LDSHARED'] = "$(CXX) -G -KPIC -lCstd"
    else
      # GNU CHAIN
      # on Unix we need a g++ link, not gcc.
      CONFIG['LDSHARED'] = "$(CXX) -shared"
    end

  when /openbsd/
    # OpenBSD branch contributed by Guillaume Sellier.

    # on Unix we need a g++ link, not gcc. On OpenBSD, linking against libstdc++ have to be explicitly done for shared libs
    CONFIG['LDSHARED'] = "$(CXX) -shared -lstdc++ -fPIC"
    CONFIG['LDSHAREDXX'] = "$(CXX) -shared -lstdc++ -fPIC"

  when /darwin/
    # on Unix we need a g++ link, not gcc.
    # Ff line contributed by Daniel Harple.
    CONFIG['LDSHARED'] = "$(CXX) " + CONFIG['LDSHARED'].split[1..-1].join(' ')

  when /aix/
    CONFIG['LDSHARED'] = "$(CXX) -shared -Wl,-G -Wl,-brtl"

  else
    # on Unix we need a g++ link, not gcc.
    CONFIG['LDSHARED'] = "$(CXX) -shared"

end

create_makefile('ext/melbourne')

File.open("Makefile","a+") do |f|
  f.puts <<END

grammar.cpp: grammar.y
	bison -o grammar.cpp grammar.y
END
end
