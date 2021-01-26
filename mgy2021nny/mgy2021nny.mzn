int: num_order_88;
int: num_order_98;

int: max_each = 100;

var 0..max_each: num_pay_88;
var 0..max_each: num_pay_98;
var 0..max_each: num_free_88;
var 0..max_each: num_free_98;

constraint num_pay_88 + num_free_88 == num_order_88;
constraint num_pay_98 + num_free_98 == num_order_98;

constraint (num_pay_88 * 88.0 + num_pay_98 * 98.0) * 0.3 >= num_free_88 * 88.0 + num_free_98 * 98;
solve minimize num_pay_88 * 88.0 + num_pay_98 * 98.0;

output [
  "total paid amount: \(num_pay_88 * 88.0 + num_pay_98 * 98.0)\n",
  "30% of total paid: \((num_pay_88 * 88.0 + num_pay_98 * 98.0) * 0.3)\n",
  "free items worth: \(num_free_88 * 88.0 + num_free_98 * 98)\n",
  "num_pay_88: \(num_pay_88)\n",
  "num_pay_98: \(num_pay_98)\n",
  "num_free_88: \(num_free_88)\n",
  "num_free_98: \(num_free_98)\n",
]