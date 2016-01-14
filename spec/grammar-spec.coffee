describe "pg grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-pg")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.pg")

  it "parses the grammar", ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe "source.pg"

  describe "when a regexp compile tokenizes", ->
    it "works with all bracket/seperator variations", ->
      {tokens} = grammar.tokenizeLine("qr/text/acdegilmoprsux;")
      expect(tokens[0]).toEqual value: "qr", scopes: ["source.pg", "string.regexp.compile.simple-delimiter.pg", "punctuation.definition.string.pg", "support.function.pg"]
      expect(tokens[1]).toEqual value: "/", scopes: ["source.pg", "string.regexp.compile.simple-delimiter.pg", "punctuation.definition.string.pg"]
      expect(tokens[2]).toEqual value: "text", scopes: ["source.pg", "string.regexp.compile.simple-delimiter.pg"]
      expect(tokens[3]).toEqual value: "/", scopes: ["source.pg", "string.regexp.compile.simple-delimiter.pg", "punctuation.definition.string.pg"]
      expect(tokens[4]).toEqual value: "acdegilmoprsux", scopes: ["source.pg", "string.regexp.compile.pg", "punctuation.definition.string.pg", "keyword.control.regexp-option.pg"]
      expect(tokens[5]).toEqual value: ";", scopes: ["source.pg"]

      {tokens} = grammar.tokenizeLine("qr(text)acdegilmoprsux;")
      expect(tokens[0]).toEqual value: "qr", scopes: ["source.pg", "string.regexp.compile.nested_parens.pg", "punctuation.definition.string.pg", "support.function.pg"]
      expect(tokens[1]).toEqual value: "(", scopes: ["source.pg", "string.regexp.compile.nested_parens.pg", "punctuation.definition.string.pg"]
      expect(tokens[2]).toEqual value: "text", scopes: ["source.pg", "string.regexp.compile.nested_parens.pg"]
      expect(tokens[3]).toEqual value: ")", scopes: ["source.pg", "string.regexp.compile.nested_parens.pg", "punctuation.definition.string.pg"]
      expect(tokens[4]).toEqual value: "acdegilmoprsux", scopes: ["source.pg", "string.regexp.compile.pg", "punctuation.definition.string.pg", "keyword.control.regexp-option.pg"]
      expect(tokens[5]).toEqual value: ";", scopes: ["source.pg"]

      {tokens} = grammar.tokenizeLine("qr{text}acdegilmoprsux;")
      expect(tokens[0]).toEqual value: "qr", scopes: ["source.pg", "string.regexp.compile.nested_braces.pg", "punctuation.definition.string.pg", "support.function.pg"]
      expect(tokens[1]).toEqual value: "{", scopes: ["source.pg", "string.regexp.compile.nested_braces.pg", "punctuation.definition.string.pg"]
      expect(tokens[2]).toEqual value: "text", scopes: ["source.pg", "string.regexp.compile.nested_braces.pg"]
      expect(tokens[3]).toEqual value: "}", scopes: ["source.pg", "string.regexp.compile.nested_braces.pg", "punctuation.definition.string.pg"]
      expect(tokens[4]).toEqual value: "acdegilmoprsux", scopes: ["source.pg", "string.regexp.compile.pg", "punctuation.definition.string.pg", "keyword.control.regexp-option.pg"]
      expect(tokens[5]).toEqual value: ";", scopes: ["source.pg"]

      {tokens} = grammar.tokenizeLine("qr[text]acdegilmoprsux;")
      expect(tokens[0]).toEqual value: "qr", scopes: ["source.pg", "string.regexp.compile.nested_brackets.pg", "punctuation.definition.string.pg", "support.function.pg"]
      expect(tokens[1]).toEqual value: "[", scopes: ["source.pg", "string.regexp.compile.nested_brackets.pg", "punctuation.definition.string.pg"]
      expect(tokens[2]).toEqual value: "text", scopes: ["source.pg", "string.regexp.compile.nested_brackets.pg"]
      expect(tokens[3]).toEqual value: "]", scopes: ["source.pg", "string.regexp.compile.nested_brackets.pg", "punctuation.definition.string.pg"]
      expect(tokens[4]).toEqual value: "acdegilmoprsux", scopes: ["source.pg", "string.regexp.compile.pg", "punctuation.definition.string.pg", "keyword.control.regexp-option.pg"]
      expect(tokens[5]).toEqual value: ";", scopes: ["source.pg"]

      {tokens} = grammar.tokenizeLine("qr<text>acdegilmoprsux;")
      expect(tokens[0]).toEqual value: "qr", scopes: ["source.pg", "string.regexp.compile.nested_ltgt.pg", "punctuation.definition.string.pg", "support.function.pg"]
      expect(tokens[1]).toEqual value: "<", scopes: ["source.pg", "string.regexp.compile.nested_ltgt.pg", "punctuation.definition.string.pg"]
      expect(tokens[2]).toEqual value: "text", scopes: ["source.pg", "string.regexp.compile.nested_ltgt.pg"]
      expect(tokens[3]).toEqual value: ">", scopes: ["source.pg", "string.regexp.compile.nested_ltgt.pg", "punctuation.definition.string.pg"]
      expect(tokens[4]).toEqual value: "acdegilmoprsux", scopes: ["source.pg", "string.regexp.compile.pg", "punctuation.definition.string.pg", "keyword.control.regexp-option.pg"]
      expect(tokens[5]).toEqual value: ";", scopes: ["source.pg"]

    it "does not treat $) as a variable", ->
      {tokens} = grammar.tokenizeLine("qr(^text$);")
      expect(tokens[2]).toEqual value: "^text", scopes: ["source.pg", "string.regexp.compile.nested_parens.pg"]
      expect(tokens[3]).toEqual value: "$", scopes: ["source.pg", "string.regexp.compile.nested_parens.pg"]
      expect(tokens[4]).toEqual value: ")", scopes: ["source.pg", "string.regexp.compile.nested_parens.pg", "punctuation.definition.string.pg"]
      expect(tokens[5]).toEqual value: ";", scopes: ["source.pg"]

    it "does not treat ( in a class as a group", ->
      {tokens} = grammar.tokenizeLine("m/ \\A [(]? [?] .* - /smx")
      expect(tokens[1]).toEqual value: "/", scopes: ["source.pg", "string.regexp.find-m.simple-delimiter.pg", "punctuation.definition.string.pg"]
      expect(tokens[5]).toEqual value: "[", scopes: ["source.pg", "string.regexp.find-m.simple-delimiter.pg"]
      expect(tokens[6]).toEqual value: "(", scopes: ["source.pg", "string.regexp.find-m.simple-delimiter.pg"]
      expect(tokens[7]).toEqual value: "]", scopes: ["source.pg", "string.regexp.find-m.simple-delimiter.pg"]
      expect(tokens[13]).toEqual value: "/", scopes: ["source.pg", "string.regexp.find-m.simple-delimiter.pg", "punctuation.definition.string.pg"]
      expect(tokens[14]).toEqual value: "smx", scopes: ["source.pg", "string.regexp.find-m.pg", "punctuation.definition.string.pg", "keyword.control.regexp-option.pg"]

    it "does not treat 'm'(hashkey) as a regex match begin", ->
      {tokens} = grammar.tokenizeLine("$foo->{m}->bar();")
      expect(tokens[3]).toEqual value: "{", scopes: ["source.pg"]
      expect(tokens[4]).toEqual value: "m", scopes: ["source.pg", "constant.other.bareword.pg"]
      expect(tokens[5]).toEqual value: "}", scopes: ["source.pg"]

  describe "when a regexp find tokenizes", ->
    it "works with all bracket/seperator variations", ->
      {tokens} = grammar.tokenizeLine(" =~ /text/acdegilmoprsux;")
      expect(tokens[0]).toEqual value: " =~", scopes: ["source.pg"]
      expect(tokens[1]).toEqual value: " ", scopes: ["source.pg"]
      expect(tokens[2]).toEqual value: "/", scopes: ["source.pg", "string.regexp.find.pg", "punctuation.definition.string.pg"]
      expect(tokens[3]).toEqual value: "text", scopes: ["source.pg", "string.regexp.find.pg"]
      expect(tokens[4]).toEqual value: "/", scopes: ["source.pg", "string.regexp.find.pg", "punctuation.definition.string.pg"]
      expect(tokens[5]).toEqual value: "acdegilmoprsux", scopes: ["source.pg", "string.regexp.find.pg", "punctuation.definition.string.pg", "keyword.control.regexp-option.pg"]
      expect(tokens[6]).toEqual value: ";", scopes: ["source.pg"]

      {tokens} = grammar.tokenizeLine(" =~ m/text/acdegilmoprsux;")
      expect(tokens[0]).toEqual value: " =~ ", scopes: ["source.pg"]
      expect(tokens[1]).toEqual value: "m", scopes: ["source.pg", "string.regexp.find-m.simple-delimiter.pg", "punctuation.definition.string.pg", "support.function.pg"]
      expect(tokens[2]).toEqual value: "/", scopes: ["source.pg", "string.regexp.find-m.simple-delimiter.pg", "punctuation.definition.string.pg"]
      expect(tokens[3]).toEqual value: "text", scopes: ["source.pg", "string.regexp.find-m.simple-delimiter.pg"]
      expect(tokens[4]).toEqual value: "/", scopes: ["source.pg", "string.regexp.find-m.simple-delimiter.pg", "punctuation.definition.string.pg"]
      expect(tokens[5]).toEqual value: "acdegilmoprsux", scopes: ["source.pg", "string.regexp.find-m.pg", "punctuation.definition.string.pg", "keyword.control.regexp-option.pg"]
      expect(tokens[6]).toEqual value: ";", scopes: ["source.pg"]

      {tokens} = grammar.tokenizeLine(" =~ m(text)acdegilmoprsux;")
      expect(tokens[0]).toEqual value: " =~ ", scopes: ["source.pg"]
      expect(tokens[1]).toEqual value: "m", scopes: ["source.pg", "string.regexp.find-m.nested_parens.pg", "punctuation.definition.string.pg", "support.function.pg"]
      expect(tokens[2]).toEqual value: "(", scopes: ["source.pg", "string.regexp.find-m.nested_parens.pg", "punctuation.definition.string.pg"]
      expect(tokens[3]).toEqual value: "text", scopes: ["source.pg", "string.regexp.find-m.nested_parens.pg"]
      expect(tokens[4]).toEqual value: ")", scopes: ["source.pg", "string.regexp.find-m.nested_parens.pg", "punctuation.definition.string.pg"]
      expect(tokens[5]).toEqual value: "acdegilmoprsux", scopes: ["source.pg", "string.regexp.find-m.pg", "punctuation.definition.string.pg", "keyword.control.regexp-option.pg"]
      expect(tokens[6]).toEqual value: ";", scopes: ["source.pg"]

      {tokens} = grammar.tokenizeLine(" =~ m{text}acdegilmoprsux;")
      expect(tokens[0]).toEqual value: " =~ ", scopes: ["source.pg"]
      expect(tokens[1]).toEqual value: "m", scopes: ["source.pg", "string.regexp.find-m.nested_braces.pg", "punctuation.definition.string.pg", "support.function.pg"]
      expect(tokens[2]).toEqual value: "{", scopes: ["source.pg", "string.regexp.find-m.nested_braces.pg", "punctuation.definition.string.pg"]
      expect(tokens[3]).toEqual value: "text", scopes: ["source.pg", "string.regexp.find-m.nested_braces.pg"]
      expect(tokens[4]).toEqual value: "}", scopes: ["source.pg", "string.regexp.find-m.nested_braces.pg", "punctuation.definition.string.pg"]
      expect(tokens[5]).toEqual value: "acdegilmoprsux", scopes: ["source.pg", "string.regexp.find-m.pg", "punctuation.definition.string.pg", "keyword.control.regexp-option.pg"]
      expect(tokens[6]).toEqual value: ";", scopes: ["source.pg"]

      {tokens} = grammar.tokenizeLine(" =~ m[text]acdegilmoprsux;")
      expect(tokens[0]).toEqual value: " =~ ", scopes: ["source.pg"]
      expect(tokens[1]).toEqual value: "m", scopes: ["source.pg", "string.regexp.find-m.nested_brackets.pg", "punctuation.definition.string.pg", "support.function.pg"]
      expect(tokens[2]).toEqual value: "[", scopes: ["source.pg", "string.regexp.find-m.nested_brackets.pg", "punctuation.definition.string.pg"]
      expect(tokens[3]).toEqual value: "text", scopes: ["source.pg", "string.regexp.find-m.nested_brackets.pg"]
      expect(tokens[4]).toEqual value: "]", scopes: ["source.pg", "string.regexp.find-m.nested_brackets.pg", "punctuation.definition.string.pg"]
      expect(tokens[5]).toEqual value: "acdegilmoprsux", scopes: ["source.pg", "string.regexp.find-m.pg", "punctuation.definition.string.pg", "keyword.control.regexp-option.pg"]
      expect(tokens[6]).toEqual value: ";", scopes: ["source.pg"]

      {tokens} = grammar.tokenizeLine(" =~ m<text>acdegilmoprsux;")
      expect(tokens[0]).toEqual value: " =~ ", scopes: ["source.pg"]
      expect(tokens[1]).toEqual value: "m", scopes: ["source.pg", "string.regexp.find-m.nested_ltgt.pg", "punctuation.definition.string.pg", "support.function.pg"]
      expect(tokens[2]).toEqual value: "<", scopes: ["source.pg", "string.regexp.find-m.nested_ltgt.pg", "punctuation.definition.string.pg"]
      expect(tokens[3]).toEqual value: "text", scopes: ["source.pg", "string.regexp.find-m.nested_ltgt.pg"]
      expect(tokens[4]).toEqual value: ">", scopes: ["source.pg", "string.regexp.find-m.nested_ltgt.pg", "punctuation.definition.string.pg"]
      expect(tokens[5]).toEqual value: "acdegilmoprsux", scopes: ["source.pg", "string.regexp.find-m.pg", "punctuation.definition.string.pg", "keyword.control.regexp-option.pg"]
      expect(tokens[6]).toEqual value: ";", scopes: ["source.pg"]

    it "works with without any character before a regexp", ->
      {tokens} = grammar.tokenizeLine("/asd/")
      expect(tokens[0]).toEqual value: "/", scopes: ["source.pg", "string.regexp.find.pg", "punctuation.definition.string.pg"]
      expect(tokens[1]).toEqual value: "asd", scopes: ["source.pg", "string.regexp.find.pg"]
      expect(tokens[2]).toEqual value: "/", scopes: ["source.pg", "string.regexp.find.pg", "punctuation.definition.string.pg"]

      {tokens} = grammar.tokenizeLine(" /asd/")
      expect(tokens[0]).toEqual value: " ", scopes: ["source.pg"]
      expect(tokens[1]).toEqual value: "/", scopes: ["source.pg", "string.regexp.find.pg", "punctuation.definition.string.pg"]
      expect(tokens[2]).toEqual value: "asd", scopes: ["source.pg", "string.regexp.find.pg"]
      expect(tokens[3]).toEqual value: "/", scopes: ["source.pg", "string.regexp.find.pg", "punctuation.definition.string.pg"]

      lines = grammar.tokenizeLines("""$asd =~
      /asd/;""")
      expect(lines[0][2]).toEqual value: " =~", scopes: ["source.pg"]
      expect(lines[1][0]).toEqual value: "/", scopes: ["source.pg", "string.regexp.find.pg", "punctuation.definition.string.pg"]
      expect(lines[1][1]).toEqual value: "asd", scopes: ["source.pg", "string.regexp.find.pg"]
      expect(lines[1][2]).toEqual value: "/", scopes: ["source.pg", "string.regexp.find.pg", "punctuation.definition.string.pg"]
      expect(lines[1][3]).toEqual value: ";", scopes: ["source.pg"]

    it "works with control keys before a regexp", ->
      {tokens} = grammar.tokenizeLine("if /asd/")
      expect(tokens[1]).toEqual value: " ", scopes: ["source.pg"]
      expect(tokens[2]).toEqual value: "/", scopes: ["source.pg", "string.regexp.find.pg", "punctuation.definition.string.pg"]
      expect(tokens[3]).toEqual value: "asd", scopes: ["source.pg", "string.regexp.find.pg"]
      expect(tokens[4]).toEqual value: "/", scopes: ["source.pg", "string.regexp.find.pg", "punctuation.definition.string.pg"]

      {tokens} = grammar.tokenizeLine("unless /asd/")
      expect(tokens[1]).toEqual value: " ", scopes: ["source.pg"]
      expect(tokens[2]).toEqual value: "/", scopes: ["source.pg", "string.regexp.find.pg", "punctuation.definition.string.pg"]
      expect(tokens[3]).toEqual value: "asd", scopes: ["source.pg", "string.regexp.find.pg"]
      expect(tokens[4]).toEqual value: "/", scopes: ["source.pg", "string.regexp.find.pg", "punctuation.definition.string.pg"]

    it "works with multiline regexp", ->
      lines = grammar.tokenizeLines("""$asd =~ /
      (\\d)
      /x""")
      expect(lines[0][2]).toEqual value: " =~", scopes: ["source.pg"]
      expect(lines[0][3]).toEqual value: " ", scopes: ["source.pg"]
      expect(lines[0][4]).toEqual value: "/", scopes: ["source.pg", "string.regexp.find.pg", "punctuation.definition.string.pg"]
      expect(lines[1][0]).toEqual value: "(", scopes: ["source.pg", "string.regexp.find.pg"]
      expect(lines[1][2]).toEqual value: ")", scopes: ["source.pg", "string.regexp.find.pg"]
      expect(lines[2][0]).toEqual value: "/", scopes: ["source.pg", "string.regexp.find.pg", "punctuation.definition.string.pg"]
      expect(lines[2][1]).toEqual value: "x", scopes: ["source.pg", "string.regexp.find.pg", "punctuation.definition.string.pg", "keyword.control.regexp-option.pg"]

    it "does not highlight a divide operation", ->
      {tokens} = grammar.tokenizeLine("my $foo = scalar(@bar)/2;")
      expect(tokens[9]).toEqual value: ")/2;", scopes: ["source.pg"]

    it "works in a if", ->
      {tokens} = grammar.tokenizeLine("if (/ hello /i) {}")
      expect(tokens[1]).toEqual value: " (", scopes: ["source.pg"]
      expect(tokens[2]).toEqual value: "/", scopes: ["source.pg", "string.regexp.find.pg", "punctuation.definition.string.pg"]
      expect(tokens[3]).toEqual value: " hello ", scopes: ["source.pg", "string.regexp.find.pg"]
      expect(tokens[4]).toEqual value: "/", scopes: ["source.pg", "string.regexp.find.pg", "punctuation.definition.string.pg"]
      expect(tokens[5]).toEqual value: "i", scopes: ["source.pg", "string.regexp.find.pg", "punctuation.definition.string.pg", "keyword.control.regexp-option.pg"]
      expect(tokens[6]).toEqual value: ") {}", scopes: ["source.pg"]

      {tokens} = grammar.tokenizeLine("if ($_ && / hello /i) {}")
      expect(tokens[5]).toEqual value: " ", scopes: ["source.pg"]
      expect(tokens[6]).toEqual value: "/", scopes: ["source.pg", "string.regexp.find.pg", "punctuation.definition.string.pg"]
      expect(tokens[7]).toEqual value: " hello ", scopes: ["source.pg", "string.regexp.find.pg"]
      expect(tokens[8]).toEqual value: "/", scopes: ["source.pg", "string.regexp.find.pg", "punctuation.definition.string.pg"]
      expect(tokens[9]).toEqual value: "i", scopes: ["source.pg", "string.regexp.find.pg", "punctuation.definition.string.pg", "keyword.control.regexp-option.pg"]
      expect(tokens[10]).toEqual value: ") {}", scopes: ["source.pg"]

  describe "when a regexp replace tokenizes", ->
    it "works with all bracket/seperator variations", ->
      {tokens} = grammar.tokenizeLine("s/text/test/acdegilmoprsux")
      expect(tokens[0]).toEqual value: "s", scopes: ["source.pg", "string.regexp.replaceXXX.simple_delimiter.pg", "punctuation.definition.string.pg", "support.function.pg"]
      expect(tokens[1]).toEqual value: "/", scopes: ["source.pg", "string.regexp.replaceXXX.simple_delimiter.pg", "punctuation.definition.string.pg"]
      expect(tokens[2]).toEqual value: "text", scopes: ["source.pg", "string.regexp.replaceXXX.simple_delimiter.pg"]
      expect(tokens[3]).toEqual value: "/", scopes: ["source.pg", "string.regexp.replaceXXX.format.simple_delimiter.pg", "punctuation.definition.string.pg"]
      expect(tokens[4]).toEqual value: "test", scopes: ["source.pg", "string.regexp.replaceXXX.format.simple_delimiter.pg"]
      expect(tokens[5]).toEqual value: "/", scopes: ["source.pg", "string.regexp.replaceXXX.format.simple_delimiter.pg", "punctuation.definition.string.pg"]
      expect(tokens[6]).toEqual value: "acdegilmoprsux", scopes: ["source.pg", "string.regexp.replace.pg", "punctuation.definition.string.pg", "keyword.control.regexp-option.pg"]

      {tokens} = grammar.tokenizeLine("s(text)(test)acdegilmoprsux")
      expect(tokens[0]).toEqual value: "s", scopes: ["source.pg", "string.regexp.nested_parens.pg", "punctuation.definition.string.pg", "support.function.pg"]
      expect(tokens[1]).toEqual value: "(", scopes: ["source.pg", "string.regexp.nested_parens.pg", "punctuation.definition.string.pg"]
      expect(tokens[2]).toEqual value: "text", scopes: ["source.pg", "string.regexp.nested_parens.pg"]
      expect(tokens[3]).toEqual value: ")", scopes: ["source.pg", "string.regexp.nested_parens.pg", "punctuation.definition.string.pg"]
      expect(tokens[4]).toEqual value: "(", scopes: ["source.pg", "string.regexp.format.nested_parens.pg", "punctuation.definition.string.pg"]
      expect(tokens[5]).toEqual value: "test", scopes: ["source.pg", "string.regexp.format.nested_parens.pg"]
      expect(tokens[6]).toEqual value: ")", scopes: ["source.pg", "string.regexp.format.nested_parens.pg", "punctuation.definition.string.pg"]
      expect(tokens[7]).toEqual value: "acdegilmoprsux", scopes: ["source.pg", "string.regexp.replace.pg", "punctuation.definition.string.pg", "keyword.control.regexp-option.pg"]

      {tokens} = grammar.tokenizeLine("s{text}{test}acdegilmoprsux")
      expect(tokens[0]).toEqual value: "s", scopes: ["source.pg", "string.regexp.nested_braces.pg", "punctuation.definition.string.pg", "support.function.pg"]
      expect(tokens[1]).toEqual value: "{", scopes: ["source.pg", "string.regexp.nested_braces.pg", "punctuation.definition.string.pg"]
      expect(tokens[2]).toEqual value: "text", scopes: ["source.pg", "string.regexp.nested_braces.pg"]
      expect(tokens[3]).toEqual value: "}", scopes: ["source.pg", "string.regexp.nested_braces.pg", "punctuation.definition.string.pg"]
      expect(tokens[4]).toEqual value: "{", scopes: ["source.pg", "string.regexp.format.nested_braces.pg", "punctuation.definition.string.pg"]
      expect(tokens[5]).toEqual value: "test", scopes: ["source.pg", "string.regexp.format.nested_braces.pg"]
      expect(tokens[6]).toEqual value: "}", scopes: ["source.pg", "string.regexp.format.nested_braces.pg", "punctuation.definition.string.pg"]
      expect(tokens[7]).toEqual value: "acdegilmoprsux", scopes: ["source.pg", "string.regexp.replace.pg", "punctuation.definition.string.pg", "keyword.control.regexp-option.pg"]

      {tokens} = grammar.tokenizeLine("s[text][test]acdegilmoprsux")
      expect(tokens[0]).toEqual value: "s", scopes: ["source.pg", "string.regexp.nested_brackets.pg", "punctuation.definition.string.pg", "support.function.pg"]
      expect(tokens[1]).toEqual value: "[", scopes: ["source.pg", "string.regexp.nested_brackets.pg", "punctuation.definition.string.pg"]
      expect(tokens[2]).toEqual value: "text", scopes: ["source.pg", "string.regexp.nested_brackets.pg"]
      expect(tokens[3]).toEqual value: "]", scopes: ["source.pg", "string.regexp.nested_brackets.pg", "punctuation.definition.string.pg"]
      expect(tokens[4]).toEqual value: "[", scopes: ["source.pg", "string.regexp.format.nested_brackets.pg", "punctuation.definition.string.pg"]
      expect(tokens[5]).toEqual value: "test", scopes: ["source.pg", "string.regexp.format.nested_brackets.pg"]
      expect(tokens[6]).toEqual value: "]", scopes: ["source.pg", "string.regexp.format.nested_brackets.pg", "punctuation.definition.string.pg"]
      expect(tokens[7]).toEqual value: "acdegilmoprsux", scopes: ["source.pg", "string.regexp.replace.pg", "punctuation.definition.string.pg", "keyword.control.regexp-option.pg"]

      {tokens} = grammar.tokenizeLine("s<text><test>acdegilmoprsux")
      expect(tokens[0]).toEqual value: "s", scopes: ["source.pg", "string.regexp.nested_ltgt.pg", "punctuation.definition.string.pg", "support.function.pg"]
      expect(tokens[1]).toEqual value: "<", scopes: ["source.pg", "string.regexp.nested_ltgt.pg", "punctuation.definition.string.pg"]
      expect(tokens[2]).toEqual value: "text", scopes: ["source.pg", "string.regexp.nested_ltgt.pg"]
      expect(tokens[3]).toEqual value: ">", scopes: ["source.pg", "string.regexp.nested_ltgt.pg", "punctuation.definition.string.pg"]
      expect(tokens[4]).toEqual value: "<", scopes: ["source.pg", "string.regexp.format.nested_ltgt.pg", "punctuation.definition.string.pg"]
      expect(tokens[5]).toEqual value: "test", scopes: ["source.pg", "string.regexp.format.nested_ltgt.pg"]
      expect(tokens[6]).toEqual value: ">", scopes: ["source.pg", "string.regexp.format.nested_ltgt.pg", "punctuation.definition.string.pg"]
      expect(tokens[7]).toEqual value: "acdegilmoprsux", scopes: ["source.pg", "string.regexp.replace.pg", "punctuation.definition.string.pg", "keyword.control.regexp-option.pg"]

      {tokens} = grammar.tokenizeLine("s_text_test_acdegilmoprsux")
      expect(tokens[0]).toEqual value: "s", scopes: ["source.pg", "string.regexp.replaceXXX.simple_delimiter.pg", "punctuation.definition.string.pg", "support.function.pg"]
      expect(tokens[1]).toEqual value: "_", scopes: ["source.pg", "string.regexp.replaceXXX.simple_delimiter.pg", "punctuation.definition.string.pg"]
      expect(tokens[2]).toEqual value: "text", scopes: ["source.pg", "string.regexp.replaceXXX.simple_delimiter.pg"]
      expect(tokens[3]).toEqual value: "_", scopes: ["source.pg", "string.regexp.replaceXXX.format.simple_delimiter.pg", "punctuation.definition.string.pg"]
      expect(tokens[4]).toEqual value: "test", scopes: ["source.pg", "string.regexp.replaceXXX.format.simple_delimiter.pg"]
      expect(tokens[5]).toEqual value: "_", scopes: ["source.pg", "string.regexp.replaceXXX.format.simple_delimiter.pg", "punctuation.definition.string.pg"]
      expect(tokens[6]).toEqual value: "acdegilmoprsux", scopes: ["source.pg", "string.regexp.replace.pg", "punctuation.definition.string.pg", "keyword.control.regexp-option.pg"]

    it "works with two '/' delimiter in the first line, and one in the last", ->
      lines = grammar.tokenizeLines("""$line =~ s/&#(\\d+);/
        chr($1)
      /gxe;""")
      expect(lines[0][4]).toEqual value: "/", scopes: ["source.pg", "string.regexp.replaceXXX.simple_delimiter.pg", "punctuation.definition.string.pg"]
      expect(lines[0][8]).toEqual value: "/", scopes: ["source.pg", "string.regexp.replaceXXX.format.simple_delimiter.pg", "punctuation.definition.string.pg"]
      expect(lines[2][0]).toEqual value: "/", scopes: ["source.pg", "string.regexp.replaceXXX.format.simple_delimiter.pg", "punctuation.definition.string.pg"]
      expect(lines[2][2]).toEqual value: ";", scopes: ["source.pg"]

    it "works with one '/' delimiter in the first line, one in the next and one in the last", ->
      lines = grammar.tokenizeLines("""$line =~ s/&#(\\d+);
      /
        chr($1)
      /gxe;""")
      expect(lines[0][4]).toEqual value: "/", scopes: ["source.pg", "string.regexp.replace.extended.simple_delimiter.pg", "punctuation.definition.string.pg"]
      expect(lines[1][0]).toEqual value: "/", scopes: ["source.pg", "string.regexp.replace.extended.simple_delimiter.pg", "punctuation.definition.string.pg"]
      expect(lines[3][0]).toEqual value: "/", scopes: ["source.pg", "string.regexp.replace.extended.simple_delimiter.pg", "punctuation.definition.string.pg"]
      expect(lines[3][2]).toEqual value: ";", scopes: ["source.pg"]

    it "works with one '/' delimiter in the first line and two in the last", ->
      lines = grammar.tokenizeLines("""$line =~ s/&#(\\d+);
      /chr($1)/gxe;""")
      expect(lines[0][4]).toEqual value: "/", scopes: ["source.pg", "string.regexp.replace.extended.simple_delimiter.pg", "punctuation.definition.string.pg"]
      expect(lines[1][0]).toEqual value: "/", scopes: ["source.pg", "string.regexp.replace.extended.simple_delimiter.pg", "punctuation.definition.string.pg"]
      expect(lines[1][5]).toEqual value: "/", scopes: ["source.pg", "string.regexp.replace.extended.simple_delimiter.pg", "punctuation.definition.string.pg"]
      expect(lines[1][7]).toEqual value: ";", scopes: ["source.pg"]

  describe "tokenizes constant variables", ->
    it "highlights constants", ->
      {tokens} = grammar.tokenizeLine("__FILE__")
      expect(tokens[0]).toEqual value: "__FILE__", scopes: ["source.pg", "constant.language.pg"]

      {tokens} = grammar.tokenizeLine("__LINE__")
      expect(tokens[0]).toEqual value: "__LINE__", scopes: ["source.pg", "constant.language.pg"]

      {tokens} = grammar.tokenizeLine("__PACKAGE__")
      expect(tokens[0]).toEqual value: "__PACKAGE__", scopes: ["source.pg", "constant.language.pg"]

      {tokens} = grammar.tokenizeLine("__SUB__")
      expect(tokens[0]).toEqual value: "__SUB__", scopes: ["source.pg", "constant.language.pg"]

      {tokens} = grammar.tokenizeLine("__END__")
      expect(tokens[0]).toEqual value: "__END__", scopes: ["source.pg", "constant.language.pg"]

      {tokens} = grammar.tokenizeLine("__DATA__")
      expect(tokens[0]).toEqual value: "__DATA__", scopes: ["source.pg", "constant.language.pg"]

    it "does highlight custom constants different", ->
      {tokens} = grammar.tokenizeLine("__TEST__")
      expect(tokens[0]).toEqual value: "__TEST__", scopes: ["source.pg", "string.unquoted.program-block.pg", "punctuation.definition.string.begin.pg"]

  describe "tokenizes compile phase keywords", ->
    it "does highlight all compile phase keywords", ->
      {tokens} = grammar.tokenizeLine("BEGIN")
      expect(tokens[0]).toEqual value: "BEGIN", scopes: ["source.pg", "meta.function.pg", "entity.name.function.pg"]

      {tokens} = grammar.tokenizeLine("UNITCHECK")
      expect(tokens[0]).toEqual value: "UNITCHECK", scopes: ["source.pg", "meta.function.pg", "entity.name.function.pg"]

      {tokens} = grammar.tokenizeLine("CHECK")
      expect(tokens[0]).toEqual value: "CHECK", scopes: ["source.pg", "meta.function.pg", "entity.name.function.pg"]

      {tokens} = grammar.tokenizeLine("INIT")
      expect(tokens[0]).toEqual value: "INIT", scopes: ["source.pg", "meta.function.pg", "entity.name.function.pg"]

      {tokens} = grammar.tokenizeLine("END")
      expect(tokens[0]).toEqual value: "END", scopes: ["source.pg", "meta.function.pg", "entity.name.function.pg"]

      {tokens} = grammar.tokenizeLine("DESTROY")
      expect(tokens[0]).toEqual value: "DESTROY", scopes: ["source.pg", "meta.function.pg", "entity.name.function.pg"]

  describe "tokenizes method calls", ->
    it "does not highlight if called like a method", ->
      {tokens} = grammar.tokenizeLine("$test->q;")
      expect(tokens[2]).toEqual value: "->", scopes: ["source.pg", "keyword.operator.comparison.pg"]
      expect(tokens[3]).toEqual value: "q;", scopes: ["source.pg"]

      {tokens} = grammar.tokenizeLine("$test->q();")
      expect(tokens[2]).toEqual value: "->", scopes: ["source.pg", "keyword.operator.comparison.pg"]
      expect(tokens[3]).toEqual value: "q();", scopes: ["source.pg"]

      {tokens} = grammar.tokenizeLine("$test->qq();")
      expect(tokens[2]).toEqual value: "->", scopes: ["source.pg", "keyword.operator.comparison.pg"]
      expect(tokens[3]).toEqual value: "qq();", scopes: ["source.pg"]

      {tokens} = grammar.tokenizeLine("$test->qw();")
      expect(tokens[2]).toEqual value: "->", scopes: ["source.pg", "keyword.operator.comparison.pg"]
      expect(tokens[3]).toEqual value: "qw();", scopes: ["source.pg"]

      {tokens} = grammar.tokenizeLine("$test->qx();")
      expect(tokens[2]).toEqual value: "->", scopes: ["source.pg", "keyword.operator.comparison.pg"]
      expect(tokens[3]).toEqual value: "qx();", scopes: ["source.pg"]

  describe "when a function call tokenizes", ->
    it "does not highlight calls which looks like a regexp", ->
      {tokens} = grammar.tokenizeLine("s_ttest($key,\"t_storage\",$single_task);")
      expect(tokens[0]).toEqual value: "s_ttest(", scopes: ["source.pg"]
      expect(tokens[3]).toEqual value: ",", scopes: ["source.pg"]
      expect(tokens[7]).toEqual value: ",", scopes: ["source.pg"]
      expect(tokens[10]).toEqual value: ");", scopes: ["source.pg"]

      {tokens} = grammar.tokenizeLine("s__ttest($key,\"t_license\",$single_task);")
      expect(tokens[0]).toEqual value: "s__ttest(", scopes: ["source.pg"]
      expect(tokens[3]).toEqual value: ",", scopes: ["source.pg"]
      expect(tokens[7]).toEqual value: ",", scopes: ["source.pg"]
      expect(tokens[10]).toEqual value: ");", scopes: ["source.pg"]

  describe "tokenizes single quoting", ->
    it "does not escape characters in single-quote strings", ->
      {tokens} = grammar.tokenizeLine("'Test this\\nsimple one';")
      expect(tokens[0]).toEqual value: "'", scopes: ["source.pg", "string.quoted.single.pg", "punctuation.definition.string.begin.pg"]
      expect(tokens[1]).toEqual value: "Test this\\nsimple one", scopes: ["source.pg", "string.quoted.single.pg"]
      expect(tokens[2]).toEqual value: "'", scopes: ["source.pg", "string.quoted.single.pg", "punctuation.definition.string.end.pg"]
      expect(tokens[3]).toEqual value: ";", scopes: ["source.pg"]

      {tokens} = grammar.tokenizeLine("q(Test this\\nsimple one);")
      expect(tokens[0]).toEqual value: "q(", scopes: ["source.pg", "string.quoted.other.q-paren.pg", "punctuation.definition.string.begin.pg"]
      expect(tokens[1]).toEqual value: "Test this\\nsimple one", scopes: ["source.pg", "string.quoted.other.q-paren.pg"]
      expect(tokens[2]).toEqual value: ")", scopes: ["source.pg", "string.quoted.other.q-paren.pg", "punctuation.definition.string.end.pg"]
      expect(tokens[3]).toEqual value: ";", scopes: ["source.pg"]

      {tokens} = grammar.tokenizeLine("q~Test this\\nadvanced one~;")
      expect(tokens[0]).toEqual value: "q~", scopes: ["source.pg", "string.quoted.other.q.pg", "punctuation.definition.string.begin.pg"]
      expect(tokens[1]).toEqual value: "Test this\\nadvanced one", scopes: ["source.pg", "string.quoted.other.q.pg"]
      expect(tokens[2]).toEqual value: "~", scopes: ["source.pg", "string.quoted.other.q.pg", "punctuation.definition.string.end.pg"]
      expect(tokens[3]).toEqual value: ";", scopes: ["source.pg"]

    it "does not escape characters in single-quote multiline strings", ->
      lines = grammar.tokenizeLines("""q(
      This is my first line\\n
      and this the second one\\x00
      last
      );""")
      expect(lines[0][0]).toEqual value: "q(", scopes: ["source.pg", "string.quoted.other.q-paren.pg", "punctuation.definition.string.begin.pg"]
      expect(lines[1][0]).toEqual value: "This is my first line\\n", scopes: ["source.pg", "string.quoted.other.q-paren.pg"]
      expect(lines[2][0]).toEqual value: "and this the second one\\x00", scopes: ["source.pg", "string.quoted.other.q-paren.pg"]
      expect(lines[3][0]).toEqual value: "last", scopes: ["source.pg", "string.quoted.other.q-paren.pg"]
      expect(lines[4][0]).toEqual value: ")", scopes: ["source.pg", "string.quoted.other.q-paren.pg", "punctuation.definition.string.end.pg"]
      expect(lines[4][1]).toEqual value: ";", scopes: ["source.pg"]

      lines = grammar.tokenizeLines("""q~
      This is my first line\\n
      and this the second one)\\x00
      last
      ~;""")
      expect(lines[0][0]).toEqual value: "q~", scopes: ["source.pg", "string.quoted.other.q.pg", "punctuation.definition.string.begin.pg"]
      expect(lines[1][0]).toEqual value: "This is my first line\\n", scopes: ["source.pg", "string.quoted.other.q.pg"]
      expect(lines[2][0]).toEqual value: "and this the second one)\\x00", scopes: ["source.pg", "string.quoted.other.q.pg"]
      expect(lines[3][0]).toEqual value: "last", scopes: ["source.pg", "string.quoted.other.q.pg"]
      expect(lines[4][0]).toEqual value: "~", scopes: ["source.pg", "string.quoted.other.q.pg", "punctuation.definition.string.end.pg"]
      expect(lines[4][1]).toEqual value: ";", scopes: ["source.pg"]

    it "does not highlight the whole word as an escape sequence", ->
      {tokens} = grammar.tokenizeLine("\"I l\\xF6ve th\\x{00E4}s\";")
      expect(tokens[0]).toEqual value: "\"", scopes: ["source.pg", "string.quoted.double.pg", "punctuation.definition.string.begin.pg"]
      expect(tokens[1]).toEqual value: "I l", scopes: ["source.pg", "string.quoted.double.pg"]
      expect(tokens[2]).toEqual value: "\\xF6", scopes: ["source.pg", "string.quoted.double.pg", "constant.character.escape.pg"]
      expect(tokens[3]).toEqual value: "ve th", scopes: ["source.pg", "string.quoted.double.pg"]
      expect(tokens[4]).toEqual value: "\\x{00E4}", scopes: ["source.pg", "string.quoted.double.pg", "constant.character.escape.pg"]
      expect(tokens[5]).toEqual value: "s", scopes: ["source.pg", "string.quoted.double.pg"]
      expect(tokens[6]).toEqual value: "\"", scopes: ["source.pg", "string.quoted.double.pg", "punctuation.definition.string.end.pg"]
      expect(tokens[7]).toEqual value: ";", scopes: ["source.pg"]

  describe "tokenizes double quoting", ->
    it "does escape characters in double-quote strings", ->
      {tokens} = grammar.tokenizeLine("\"Test\\tthis\\nsimple one\";")
      expect(tokens[0]).toEqual value: "\"", scopes: ["source.pg", "string.quoted.double.pg", "punctuation.definition.string.begin.pg"]
      expect(tokens[1]).toEqual value: "Test", scopes: ["source.pg", "string.quoted.double.pg"]
      expect(tokens[2]).toEqual value: "\\t", scopes: ["source.pg", "string.quoted.double.pg", "constant.character.escape.pg"]
      expect(tokens[3]).toEqual value: "this", scopes: ["source.pg", "string.quoted.double.pg"]
      expect(tokens[4]).toEqual value: "\\n", scopes: ["source.pg", "string.quoted.double.pg", "constant.character.escape.pg"]
      expect(tokens[5]).toEqual value: "simple one", scopes: ["source.pg", "string.quoted.double.pg"]
      expect(tokens[6]).toEqual value: "\"", scopes: ["source.pg", "string.quoted.double.pg", "punctuation.definition.string.end.pg"]
      expect(tokens[7]).toEqual value: ";", scopes: ["source.pg"]

      {tokens} = grammar.tokenizeLine("qq(Test\\tthis\\nsimple one);")
      expect(tokens[0]).toEqual value: "qq(", scopes: ["source.pg", "string.quoted.other.qq-paren.pg", "punctuation.definition.string.begin.pg"]
      expect(tokens[1]).toEqual value: "Test", scopes: ["source.pg", "string.quoted.other.qq-paren.pg"]
      expect(tokens[2]).toEqual value: "\\t", scopes: ["source.pg", "string.quoted.other.qq-paren.pg", "constant.character.escape.pg"]
      expect(tokens[3]).toEqual value: "this", scopes: ["source.pg", "string.quoted.other.qq-paren.pg"]
      expect(tokens[4]).toEqual value: "\\n", scopes: ["source.pg", "string.quoted.other.qq-paren.pg", "constant.character.escape.pg"]
      expect(tokens[5]).toEqual value: "simple one", scopes: ["source.pg", "string.quoted.other.qq-paren.pg"]
      expect(tokens[6]).toEqual value: ")", scopes: ["source.pg", "string.quoted.other.qq-paren.pg", "punctuation.definition.string.end.pg"]
      expect(tokens[7]).toEqual value: ";", scopes: ["source.pg"]

      {tokens} = grammar.tokenizeLine("qq~Test\\tthis\\nadvanced one~;")
      expect(tokens[0]).toEqual value: "qq~", scopes: ["source.pg", "string.quoted.other.qq.pg", "punctuation.definition.string.begin.pg"]
      expect(tokens[1]).toEqual value: "Test", scopes: ["source.pg", "string.quoted.other.qq.pg"]
      expect(tokens[2]).toEqual value: "\\t", scopes: ["source.pg", "string.quoted.other.qq.pg", "constant.character.escape.pg"]
      expect(tokens[3]).toEqual value: "this", scopes: ["source.pg", "string.quoted.other.qq.pg"]
      expect(tokens[4]).toEqual value: "\\n", scopes: ["source.pg", "string.quoted.other.qq.pg", "constant.character.escape.pg"]
      expect(tokens[5]).toEqual value: "advanced one", scopes: ["source.pg", "string.quoted.other.qq.pg"]
      expect(tokens[6]).toEqual value: "~", scopes: ["source.pg", "string.quoted.other.qq.pg", "punctuation.definition.string.end.pg"]
      expect(tokens[7]).toEqual value: ";", scopes: ["source.pg"]

  describe "tokenizes word quoting", ->
    it "quotes words", ->
      {tokens} = grammar.tokenizeLine("qw(Aword Bword Cword);")
      expect(tokens[0]).toEqual value: "qw(", scopes: ["source.pg", "string.quoted.other.q-paren.pg", "punctuation.definition.string.begin.pg"]
      expect(tokens[1]).toEqual value: "Aword Bword Cword", scopes: ["source.pg", "string.quoted.other.q-paren.pg"]
      expect(tokens[2]).toEqual value: ")", scopes: ["source.pg", "string.quoted.other.q-paren.pg", "punctuation.definition.string.end.pg"]
      expect(tokens[3]).toEqual value: ";", scopes: ["source.pg"]

  describe "tokenizes subroutines", ->
    it "does highlight subroutines", ->
      lines = grammar.tokenizeLines("""sub mySub {
          print "asd";
      }""")
      expect(lines[0][0]).toEqual value: "sub", scopes: ["source.pg", "meta.function.pg", "storage.type.sub.pg"]
      expect(lines[0][2]).toEqual value: "mySub", scopes: ["source.pg", "meta.function.pg", "entity.name.function.pg"]
      expect(lines[0][4]).toEqual value: "{", scopes: ["source.pg"]
      expect(lines[2][0]).toEqual value: "}", scopes: ["source.pg"]

    it "does highlight subroutines assigned to a variable", ->
      lines = grammar.tokenizeLines("""my $test = sub {
          print "asd";
      };""")
      expect(lines[0][5]).toEqual value: "sub", scopes: ["source.pg", "meta.function.pg", "storage.type.sub.pg"]
      expect(lines[0][7]).toEqual value: "{", scopes: ["source.pg"]
      expect(lines[2][0]).toEqual value: "};", scopes: ["source.pg"]

    it "does highlight subroutines assigned to a hash key", ->
      lines = grammar.tokenizeLines("""my $test = { a => sub {
          print "asd";
      }};""")
      expect(lines[0][9]).toEqual value: "sub", scopes: ["source.pg", "meta.function.pg", "storage.type.sub.pg"]
      expect(lines[0][11]).toEqual value: "{", scopes: ["source.pg"]
      expect(lines[2][0]).toEqual value: "}};", scopes: ["source.pg"]

  describe "tokenizes format", ->
    it "works as expected", ->
      lines = grammar.tokenizeLines("""format STDOUT_TOP =
                     Passwd File
Name                Login    Office   Uid   Gid Home
------------------------------------------------------------------
.
format STDOUT =
@<<<<<<<<<<<<<<<<<< @||||||| @<<<<<<@>>>> @>>>> @<<<<<<<<<<<<<<<<<
$name,              $login,  $office,$uid,$gid, $home
.""")
      expect(lines[0][0]).toEqual value: "format", scopes: ["source.pg", "meta.format.pg", "support.function.pg"]
      expect(lines[0][2]).toEqual value: "STDOUT_TOP", scopes: ["source.pg", "meta.format.pg", "entity.name.function.format.pg"]
      expect(lines[1][0]).toEqual value: "Passwd File", scopes: ["source.pg", "meta.format.pg"]
      expect(lines[2][0]).toEqual value: "Name                Login    Office   Uid   Gid Home", scopes: ["source.pg", "meta.format.pg"]
      expect(lines[3][0]).toEqual value: "------------------------------------------------------------------", scopes: ["source.pg", "meta.format.pg"]
      expect(lines[4][0]).toEqual value: ".", scopes: ["source.pg", "meta.format.pg"]
      expect(lines[5][0]).toEqual value: "format", scopes: ["source.pg", "meta.format.pg", "support.function.pg"]
      expect(lines[5][2]).toEqual value: "STDOUT", scopes: ["source.pg", "meta.format.pg", "entity.name.function.format.pg"]
      expect(lines[6][0]).toEqual value: "@<<<<<<<<<<<<<<<<<< @||||||| @<<<<<<@>>>> @>>>> @<<<<<<<<<<<<<<<<<", scopes: ["source.pg", "meta.format.pg"]
      expect(lines[8][0]).toEqual value: ".", scopes: ["source.pg", "meta.format.pg"]

      lines = grammar.tokenizeLines("""format STDOUT_TOP =
                         Bug Reports
@<<<<<<<<<<<<<<<<<<<<<<<     @|||         @>>>>>>>>>>>>>>>>>>>>>>>
$system,                      $%,         $date
------------------------------------------------------------------
.
format STDOUT =
Subject: @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      $subject
Index: @<<<<<<<<<<<<<<<<<<<<<<<<<<<< ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    $index,                       $description
Priority: @<<<<<<<<<< Date: @<<<<<<< ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<
       $priority,        $date,   $description
From: @<<<<<<<<<<<<<<<<<<<<<<<<<<<<< ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<
   $from,                         $description
Assigned to: @<<<<<<<<<<<<<<<<<<<<<< ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<
          $programmer,            $description
~                                    ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                                  $description
~                                    ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                                  $description
~                                    ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                                  $description
~                                    ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                                  $description
~                                    ^<<<<<<<<<<<<<<<<<<<<<<<...
                                  $description
.""")
      expect(lines[0][0]).toEqual value: "format", scopes: ["source.pg", "meta.format.pg", "support.function.pg"]
      expect(lines[0][2]).toEqual value: "STDOUT_TOP", scopes: ["source.pg", "meta.format.pg", "entity.name.function.format.pg"]
      expect(lines[2][0]).toEqual value: "@<<<<<<<<<<<<<<<<<<<<<<<     @|||         @>>>>>>>>>>>>>>>>>>>>>>>", scopes: ["source.pg", "meta.format.pg"]
      expect(lines[4][0]).toEqual value: "------------------------------------------------------------------", scopes: ["source.pg", "meta.format.pg"]
      expect(lines[5][0]).toEqual value: ".", scopes: ["source.pg", "meta.format.pg"]
      expect(lines[6][0]).toEqual value: "format", scopes: ["source.pg", "meta.format.pg", "support.function.pg"]
      expect(lines[6][2]).toEqual value: "STDOUT", scopes: ["source.pg", "meta.format.pg", "entity.name.function.format.pg"]
      expect(lines[7][0]).toEqual value: "Subject: @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<", scopes: ["source.pg", "meta.format.pg"]
      expect(lines[9][0]).toEqual value: "Index: @<<<<<<<<<<<<<<<<<<<<<<<<<<<< ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<", scopes: ["source.pg", "meta.format.pg"]
      expect(lines[11][0]).toEqual value: "Priority: @<<<<<<<<<< Date: @<<<<<<< ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<", scopes: ["source.pg", "meta.format.pg"]
      expect(lines[13][0]).toEqual value: "From: @<<<<<<<<<<<<<<<<<<<<<<<<<<<<< ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<", scopes: ["source.pg", "meta.format.pg"]
      expect(lines[15][0]).toEqual value: "Assigned to: @<<<<<<<<<<<<<<<<<<<<<< ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<", scopes: ["source.pg", "meta.format.pg"]
      expect(lines[17][0]).toEqual value: "~                                    ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<", scopes: ["source.pg", "meta.format.pg"]
      expect(lines[19][0]).toEqual value: "~                                    ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<", scopes: ["source.pg", "meta.format.pg"]
      expect(lines[21][0]).toEqual value: "~                                    ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<", scopes: ["source.pg", "meta.format.pg"]
      expect(lines[23][0]).toEqual value: "~                                    ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<", scopes: ["source.pg", "meta.format.pg"]
      expect(lines[25][0]).toEqual value: "~                                    ^<<<<<<<<<<<<<<<<<<<<<<<...", scopes: ["source.pg", "meta.format.pg"]
      expect(lines[27][0]).toEqual value: ".", scopes: ["source.pg", "meta.format.pg"]

  describe "when a heredoc tokenizes", ->
    it "does not highlight the whole line", ->
      lines = grammar.tokenizeLines("""$asd->foo(<<TEST, $bar, s/foo/bar/g);
asd
TEST
;""")
      expect(lines[0][4]).toEqual value: "<<", scopes: ["source.pg", "punctuation.definition.string.pg", "string.unquoted.heredoc.pg", "punctuation.definition.heredoc.pg"]
      expect(lines[0][5]).toEqual value: "TEST", scopes: ["source.pg", "punctuation.definition.string.pg", "string.unquoted.heredoc.pg"]
      expect(lines[0][6]).toEqual value: ", ", scopes: ["source.pg"]
      expect(lines[3][0]).toEqual value: ";", scopes: ["source.pg"]

    it "does not highlight variables and escape sequences in a single quote heredoc", ->
      lines = grammar.tokenizeLines("""$asd->foo(<<'TEST');
$asd\\n
;""")
      expect(lines[1][0]).toEqual value: "$asd\\n", scopes: ["source.pg", "string.unquoted.heredoc.quote.pg"]

      lines = grammar.tokenizeLines("""$asd->foo(<<\\TEST);
$asd\\n
;""")
      expect(lines[1][0]).toEqual value: "$asd\\n", scopes: ["source.pg", "string.unquoted.heredoc.quote.pg"]

  describe "when a hash variable tokenizes", ->
    it "does not highlight whitespace beside a key as a constant", ->
      lines = grammar.tokenizeLines("""my %hash = (
  key => 'value1',
  'key' => 'value2'
);""")
      expect(lines[1][0]).toEqual value: "key", scopes: ["source.pg", "constant.other.key.pg"]
      expect(lines[1][1]).toEqual value: " ", scopes: ["source.pg"]
      expect(lines[2][0]).toEqual value: "'", scopes: ["source.pg", "string.quoted.single.pg", "punctuation.definition.string.begin.pg"]
      expect(lines[2][1]).toEqual value: "key", scopes: ["source.pg", "string.quoted.single.pg"]
      expect(lines[2][2]).toEqual value: "'", scopes: ["source.pg", "string.quoted.single.pg", "punctuation.definition.string.end.pg"]
      expect(lines[2][3]).toEqual value: " ", scopes: ["source.pg"]

  describe "when package to tokenizes", ->
    it "does not highlight semicolon in package name", ->
      {tokens} = grammar.tokenizeLine("package Test::ASD; #this is my new class")
      expect(tokens[0]).toEqual value: "package", scopes: ["source.pg", "meta.class.pg", "keyword.control.pg"]
      expect(tokens[1]).toEqual value: " ", scopes: ["source.pg", "meta.class.pg"]
      expect(tokens[2]).toEqual value: "Test::ASD", scopes: ["source.pg", "meta.class.pg", "entity.name.type.class.pg"]
      expect(tokens[3]).toEqual value: "; ", scopes: ["source.pg"]
      expect(tokens[4]).toEqual value: "#", scopes: ["source.pg", "comment.line.number-sign.pg", "punctuation.definition.comment.pg"]
      expect(tokens[5]).toEqual value: "this is my new class", scopes: ["source.pg", "comment.line.number-sign.pg"]
