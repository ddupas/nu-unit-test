#!/usr/bin/env nu
#
# nu-unit-test-example.nu
#
#

use nu-unit-test 'test run'

### test subjects

#[test subject]
def "url parse filename" [] {  # -> string
    url parse | get path | path parse | update parent "" | path join
}

#[test subject]
def "bing url parse filename" [] {  # -> string
    url parse | get params.id
}

### tests

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

tests = [ (test url parse) (test bing url parse) ]
test run $tests
