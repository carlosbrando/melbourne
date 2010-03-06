#include "ruby.h"
#include "grammar.hpp"
#include "symbols.hpp"

#ifdef __cplusplus
  extern "C" {
#endif

VALUE melbourne_string_to_ast(VALUE self, VALUE source, VALUE name, VALUE line) {
  bstring b_str = blk2bstr(RSTRING_PTR(source), RSTRING_LEN(source));
  VALUE result = melbourne::string_to_ast(self, RSTRING_PTR(name), b_str, FIX2INT(line));
  bdestroy(b_str);
  return result;
}

VALUE melbourne_file_to_ast(VALUE self, VALUE fname, VALUE start) {
  FILE *file = fopen(RSTRING_PTR(fname), "r");
  if(file) {
    VALUE result = melbourne::file_to_ast(self, RSTRING_PTR(fname), file, FIX2INT(start));
    fclose(file);
    return result;
  } else {
    rb_raise(rb_eLoadError, "no such file to load -- %s", RSTRING_PTR(fname));
  }
}

void Init_melbourne(void) {
  melbourne::init_symbols();
  VALUE rb_mMelbourne = rb_define_module("Melbourne");
  VALUE rb_cParser = rb_define_class_under(rb_mMelbourne, "Parser", rb_cObject);
  rb_define_method(rb_cParser, "string_to_ast", RUBY_METHOD_FUNC(melbourne_string_to_ast), 3);
  rb_define_method(rb_cParser, "file_to_ast", RUBY_METHOD_FUNC(melbourne_file_to_ast), 2);
}

#ifdef __cplusplus
  }  /* extern "C" { */
#endif
