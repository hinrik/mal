unit module printer;
use types;

sub pr_str ($exp, $print_readably = False) is export {
  my &reprint = { pr_str($^a, $print_readably) };
  given $exp {
    when MalFunction { "#<fn* ({$exp.params}) {pr_str($exp.ast)}>" }
    when MalCode { "#<builtin_fn* {$exp.fn.gist}>" }
    when MalList {
      '(' ~ join(' ', |$exp.map({ &reprint($_) })) ~ ')';
    }
    when MalVector {
      '[' ~ join(' ', |$exp.map({ &reprint($_) })) ~ ']';
    }
    when MalHashMap {
      '{' ~ $exp.kv.flatmap({ MalString($^a), $^b }).map({ &reprint($_) }) ~ '}'
    }
    when MalString {
      my $str = $exp.val;
      if $str ~~ s/^\x29E/:/ || !$print_readably {
        $str;
      }
      else {
        '"' ~ $str.trans(/\\/ => '\\\\', /\"/ => '\\"', /\n/ => '\\n') ~ '"';
      }
    }
    when MalAtom { "(atom {&reprint($exp.val)})" }
    when MalValue { $exp.val }
  }
}
