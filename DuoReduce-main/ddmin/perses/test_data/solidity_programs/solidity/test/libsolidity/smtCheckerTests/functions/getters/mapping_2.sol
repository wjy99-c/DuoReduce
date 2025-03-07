pragma experimental SMTChecker;

contract C {
	mapping (uint => mapping (uint => uint)) public map;

	function f() public view {
		uint y = this.map(2, 3);
		assert(y == map[2][3]); // should hold
		assert(y == 1); // should fail
	}
}
// ----
// Warning 6328: (199-213): CHC: Assertion violation happens here.\nCounterexample:\n\ny = 0\n\nTransaction trace:\nC.constructor()\nC.f()
