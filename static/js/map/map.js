document.addEventListener("DOMContentLoaded", function () {
  const observer = new IntersectionObserver(entries => {

    entries.forEach(entry => {
      const id = entry.target.getAttribute('id');
      //console.log(id);

      if (entry.intersectionRatio > 0) {
        document.querySelector(`.index-sticky-nav a[href="#${id}"]`).classList.add('active');
        // console.log("on screen");
        // console.log(entry.intersectionRatio);
        // console.log(entry.boundingClientRect);
      }
      else {
        document.querySelector(`.index-sticky-nav a[href="#${id}"]`).classList.remove('active');
        // console.log("off screen");
        // console.log(entry.intersectionRatio);
        // console.log(entry.boundingClientRect);
      }

    });
  });

  // Track all sections that have an `id` applied
  document.querySelectorAll('section[id]').forEach((section) => {
    observer.observe(section);
  });

  var thisStep = 0;
  var howStep = document.querySelectorAll('.how-step');
  var howDesp = document.querySelectorAll('.how-desp');
  var howImg = document.querySelectorAll('.how-image');
  //var element = document.getElementsByClassName('how-step');
  for (var i = 0; i < howStep.length; i++) {
    howStep[i].onclick = function (e) {
      thisStep = e.target.getAttribute('data-num');

      howStep.forEach((step) => {
        step.classList.remove('active', 'bg-white');
        step.classList.add('text-white', 'font-bold');
      });
      howStep[thisStep].classList.remove('text-white', 'font-bold');
      howStep[thisStep].classList.add('active', 'bg-white');

      howDesp.forEach((desp) => {
        desp.classList.remove('block');
        desp.classList.add('hidden');
      });
      howDesp[thisStep].classList.remove('hidden');
      howDesp[thisStep].classList.add('block');

      howImg.forEach((imgg) => {
        imgg.classList.remove('block');
        imgg.classList.add('hidden');
      });
      howImg[thisStep].classList.remove('hidden');
      howImg[thisStep].classList.add('block');
    }
  }
})

  
