# nu-unit-test
unit test framework for nu


references:
- https://en.wikipedia.org/wiki/XUnit
- https://en.wikipedia.org/wiki/JUnit


## objectives

- create an assert function that can fail and continue on with other tests:

- create a runner that follows the junit test fixture
pattern of:
```
before all
    before each
    test
    after each
after all
```

that allows for setup and teardown of a test session and each test
