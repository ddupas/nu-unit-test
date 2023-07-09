#!/usr/bin/env nu
#
# nu-unit-test.nu
# emulate a junit test fixture in nushell
#




#
# unit assert, test a condition and report the result
#
def 'unit assert' [
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
def 'unit assert equal' [left: any, right: any, message?: string] {
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




### test subjects

#[test subject]
def "url parse filename" [] {  # -> string
    url parse | get path | path parse | update parent "" | path join
}

#[test subject]
def "bing url parse filename" [] {  # -> string
    url parse | get params.id
}



#### some tests

#[test]
def 'test ok' [] {
    return {
        name: 'test ok'
        result: ( unit assert (0 == 0)  )
    }
}

def 'test not ok' [] {
    return {
        name: 'test not ok'
        result: ( unit assert (1 == 0)  )
    }
}

#[test]
def 'test url parse' [] {
    let input = "https://i.natgeofe.com/n/ffe12b1d-8191-44ec-bfb9-298e0dd29825/NationalGeographic_2745739.jpg"
    let expected = "NationalGeographic_2745739.jpg"
    return {
        name: 'test url parse'
        result: ( unit assert equal ($input | url parse filename) $expected )
    }
}

#[test]
def 'test bing url parse' [] {
    let input = "http://bing.com/th?id=OHR.CorfuBeach_EN-US1955770867_1920x1080.jpg&rf=LaDigue_1920xs1080.jpg&pid=hp"
    let expected = "OHR.CorfuBeach_EN-US1955770867_1920x1080.jpg"
    return {
        name: 'test bing url parse'
        result: ( unit assert equal ($input | bing url parse filename) $expected )
    }
}


# runs once at the start of test run
def 'test before all' [] {
    'insert set up before all' | print
    ()
}

# gets called every test
def 'test before each' [] {
    'insert set up before each' | print
    ()
}

# tear down code after each test
def 'test after each' [] {
    'insert tear down after each' | print
    ()
}

# tear down code after last test
def 'test after all' [] {
    'insert tear down after all' | print
    ()
}



let tests = [ (test ok) (test not ok) (test url parse) (test ok) (test bing url parse) ]



export def 'test run' [] {
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

def 'show results' [] {
        let results = ( test run )
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

show results
#unit assert ( true ) | describe


}
