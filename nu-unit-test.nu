#!/usr/bin/env nu
#
# nu-unit-test.nu
# emulate a junit test fixture in nushell
#




#
# unit assert, test a condition and report the result
#
export def 'unit assert' [
    condition: bool, # Condition, which should be true
    message?: string, # Optional error message
    --error-label: record # Label for custom assert
    --success-label: record
] {

    let span = (metadata $condition).span

    if $condition {
     return {
        msg: ($message | default "Assertion passed."),
        label: ($success_label | default {
            text: "It is true.",
            start: $span.start,
            end: $span.end
        })
    }
    }

    return {
        msg: ($message | default "Assertion failed."),
        label: ($error_label | default {
            text: "It is not true.",
            start: $span.start,
            end: $span.end
        })
    }
}

#
# unit assert $left == $right
#
export def 'unit assert equal' [left: any, right: any, message?: string] {
    unit assert ($left == $right) $message --error-label {
        start: (metadata $left).span.start
        end: (metadata $right).span.end
        text: $"They are not equal. Left = '($left)'. Right = '($right)'."
    } --success-label {
        start: (metadata $left).span.start
        end: (metadata $right).span.end
        text: $"They are equal. Left = '($left)'. Right = '($right)'."
    }
}


#### some tests

#[test]
def 'test ok' [] {
    return {
        name: 'test ok'
        result: ( unit assert (0 == 0)  )
    }
}

#[test]
def 'test not ok' [] {
    return {
        name: 'test not ok'
        result: ( unit assert (1 == 0)  )
    }
}

#[test]
def 'test ok equal' [] {
    let input = 'value'
    let expected = 'value'
    return {
        name: 'test ok equal'
        result:( unit assert equal $input $expected)
    }
}

#[test]
def 'test not ok equal' [] {
    let input = 'value'
    let expected = 'wrong'
    return {
        name: 'test not ok equal'
        result: ( unit assert equal $input $expected  )
    }
}

# CALLBACK
# runs once at the start of test run
def 'test before all' [] {
    'insert set up before all' | print
    ()
}

# CALLBACK
# gets called every test
def 'test before each' [] {
    'insert set up before each' | print
    ()
}

# CALLBACK
# tear down code after each test
def 'test after each' [] {
    'insert tear down after each' | print
    ()
}

# CALLBACK
# tear down code after last test
def 'test after all' [] {
    'insert tear down after all' | print
    ()
}


# this is the main export of this module!
# it accepts a list of functions to test right now
#
# TODO: provide means of injecting the 4 CALLBACKS
#
# TODO: study execution context, if there is such a thing env likely
#

export def 'test run' [tests:list<any>] {  #-> list<any>
    test before all
    let results = ( $tests | each {|test|
        test before each

            let r = ( $test )

            print $r.name

        test after each
        $r
       }
    )
   test after all
   $results
}


def 'show selftest results' [] {
        let selftests = [

(test ok)
(test not ok)
(test ok equal)
(test not ok equal)

]
        let results = ( test run $selftests )
        '
======== test results =========' | print
        $results
            | each { |result|
            '
======== test =========' | print
            print  $result.name
            $result.result
                | each { |r|
                    print $r.msg
                    $r.label
                        | each { |l|
                            print $l
                        }
                }
    }
    ()
}

export def main [] {
'
====== this is a module but we can test it with itself by executing main  =========' | print

    show selftest results
}
