# nu-unit-test
unit test framework for nu


references:
https://en.wikipedia.org/wiki/XUnit
https://en.wikipedia.org/wiki/JUnit


## objectives

- create and assert that can fail and continue on with other tests

- create a runner that follows the junit test fixture
pattern of:
```
Before All
    BeforeEach
        Test
    After Each
After All
```

that allows for setup and teardown of a test session and each test
