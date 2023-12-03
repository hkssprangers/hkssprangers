class Test {
    static function main() {
        utest.UTest.run([
            new TestMenuSchema(),
            new TestTelegramTools(),
            new TestBlackWindow(),
        ]);
    }
}
