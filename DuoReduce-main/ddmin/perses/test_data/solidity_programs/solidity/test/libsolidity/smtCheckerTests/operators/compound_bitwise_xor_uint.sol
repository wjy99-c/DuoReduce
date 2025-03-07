pragma experimental SMTChecker;

contract C {
    function f() public pure {
        uint v = 7;
        v ^= 3;
        assert(v != 4); // fails, as 7 ^ 3 = 4

        uint c = 0;
        c ^= v;
        assert(c == 4);

        uint16 x = 0xff;
        uint16 y = 0xffff;
        y ^= x;
        assert(y == 0xff); // fails
        assert(y == 0xff00);

        y = 0xf1;
        x = 0xff00;
        y ^= x | y;
        assert(y == 0xffff); // fails
        assert(x == 0xff00);
    }
}
// ----
// Warning 6328: (121-135): CHC: Assertion violation happens here.\nCounterexample:\n\nv = 4\nc = 0\nx = 0\ny = 0\n\nTransaction trace:\nC.constructor()\nC.f()
// Warning 6328: (298-315): CHC: Assertion violation happens here.\nCounterexample:\n\nv = 4\nc = 4\nx = 255\ny = 65280\n\nTransaction trace:\nC.constructor()\nC.f()
// Warning 6328: (422-441): CHC: Assertion violation happens here.\nCounterexample:\n\nv = 4\nc = 4\nx = 65280\ny = 65280\n\nTransaction trace:\nC.constructor()\nC.f()
