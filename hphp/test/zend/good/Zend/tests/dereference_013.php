<?hh

error_reporting(E_ALL);

class foo {
	public $x = array(2);

	public function __call($x, $y) {
		if (count($this->x) == 1) {
			$this->x[] = $y[0];
		}
		return $this->x;
	}
}

$foo = new foo;

$x = array(1);

$foo->b($x)[1] = 3;

var_dump($foo->b()[0]);
var_dump($foo->b()[1]);
try { var_dump($foo->b()[2]); } catch (Exception $e) { echo $e->getMessage()."\n"; }
