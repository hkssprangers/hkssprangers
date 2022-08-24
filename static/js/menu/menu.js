document.addEventListener("DOMContentLoaded", function () {
    document.getElementById('menuBtn').addEventListener("click", toggleNav);

        function toggleNav() {
            console.log('addd');
            document.getElementById('mmenu').classList.toggle("open");
            var list = document.getElementsByClassName("navicon");
            for (var i = 0; i < list.length; i++) {
                list[i].classList.toggle("open");
            }
        }
});