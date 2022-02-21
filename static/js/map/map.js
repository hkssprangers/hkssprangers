document.addEventListener("DOMContentLoaded", function () {
  mapboxgl.accessToken = 'pk.eyJ1Ijoic3RlbGxhNzExIiwiYSI6ImNrc3p2OXMzMDJnc2Yyd24xZXZ0ZGt4cGQifQ.Vn6lqChhc0FXjQ_WQWnd-w';
  const map = new mapboxgl.Map({
    container: 'map', // container ID
    style: 'mapbox://styles/onthewings/ckzwgjip4004215oce0zc5ola', // style URL
    center: [114.16025186047068, 22.33114444434112], // starting position [lng, lat]
    zoom: 15 // starting zoom
  });

  const popupEightyNine = new mapboxgl.Popup({ offset: 25 }).setText(
    '89美食'
  );
  const popupLaksaStore = new mapboxgl.Popup({ offset: 25 }).setText(
    '喇沙專門店'
  );
  const popupKCZenzero = new mapboxgl.Popup({ offset: 25 }).setText(
    '蕃廚'
  );
  const popupHanaSoftCream = new mapboxgl.Popup({ offset: 25 }).setText(
    'HANA SOFT CREAM'
  );
  const popupWoStreet = new mapboxgl.Popup({ offset: 25 }).setText(
    '窩Street'
  );
  const popupBiuKeeLokYuen = new mapboxgl.Popup({ offset: 25 }).setText(
    '標記樂園潮州粉麵菜館'
  );
  const popupFastTasteSSP = new mapboxgl.Popup({ offset: 25 }).setText(
    'Fast Taste SSP'
  );
  const popupNeighbor = new mapboxgl.Popup({ offset: 25 }).setText(
    'Neighbor'
  );
  const popupTheParkByYears = new mapboxgl.Popup({ offset: 25 }).setText(
    'The Park by Years'
  );
  const popupMGY = new mapboxgl.Popup({ offset: 25 }).setText(
    '梅貴緣'
  );
  const popupPokeGo = new mapboxgl.Popup({ offset: 25 }).setText(
    'Poke Go'
  );
  const popupMinimal = new mapboxgl.Popup({ offset: 25 }).setText(
    'Minimal'
  );
  const popupYearsHK = new mapboxgl.Popup({ offset: 25 }).setText(
    'Years'
  );
  const popupZeppelinHotDogSKM = new mapboxgl.Popup({ offset: 25 }).setText(
    'Zeppelin Hot Dog'
  );
  const popupToolss = new mapboxgl.Popup({ offset: 25 }).setText(
    'Toolss'
  );
  const popupKeiHing = new mapboxgl.Popup({ offset: 25 }).setText(
    '琦興餐廳'
  );

  const red1 = new mapboxgl.Marker({ color: 'rgb(239,68,68)' })
    .setLngLat([114.15999719142565, 22.331322836819467]).setPopup(popupEightyNine)
    .addTo(map);

  const red2 = new mapboxgl.Marker({ color: 'rgb(239,68,68)' })
    .setLngLat([114.16018510255412, 22.331224492274075]).setPopup(popupLaksaStore)
    .addTo(map);

  const red4 = new mapboxgl.Marker({ color: 'rgb(239,68,68)' })
    .setLngLat([114.16008933227181, 22.331250206095916]).setPopup(popupKCZenzero)
    .addTo(map);

  const red5 = new mapboxgl.Marker({ color: 'rgb(239,68,68)' })
    .setLngLat([114.15992709862553, 22.33131448514895]).setPopup(popupHanaSoftCream)
    .addTo(map);

  const red6 = new mapboxgl.Marker({ color: 'rgb(239,68,68)' })
    .setLngLat([114.15980968380086, 22.33122676249549]).setPopup(popupWoStreet)
    .addTo(map);

  const pink1 = new mapboxgl.Marker({ color: 'rgb(236, 72, 153)' })
    .setLngLat([114.16249194087277, 22.331307624504262]).setPopup(popupBiuKeeLokYuen)
    .addTo(map);

  const pink2 = new mapboxgl.Marker({ color: 'rgb(236, 72, 153)' })
    .setLngLat([114.16288103123213, 22.331219487568305]).setPopup(popupFastTasteSSP)
    .addTo(map);

  const yellow1 = new mapboxgl.Marker({ color: 'rgb(245, 158, 11)' })
    .setLngLat([114.15993884998386, 22.335030983704257]).setPopup(popupNeighbor)
    .addTo(map);

  const green1 = new mapboxgl.Marker({ color: 'rgb(5, 150, 105)' })
    .setLngLat([114.16393714588742, 22.32790793020368]).setPopup(popupTheParkByYears)
    .addTo(map);

  const green2 = new mapboxgl.Marker({ color: 'rgb(5, 150, 105)' })
    .setLngLat([114.16299112236447, 22.328139918152658]).setPopup(popupMGY)
    .addTo(map);

  const green3 = new mapboxgl.Marker({ color: 'rgb(5, 150, 105)' })
    .setLngLat([114.162689501356, 22.327606976092454]).setPopup(popupPokeGo)
    .addTo(map);

  const green4 = new mapboxgl.Marker({ color: 'rgb(5, 150, 105)' })
    .setLngLat([114.1636431, 22.3288335]).setPopup(popupMinimal)
    .addTo(map);

  const greenn1 = new mapboxgl.Marker({ color: 'rgb(52, 211, 153)' })
    .setLngLat([114.16075597211704, 22.332666679934732]).setPopup(popupYearsHK)
    .addTo(map);

  const blue1 = new mapboxgl.Marker({ color: 'rgb(59, 130, 246)' })
    .setLngLat([114.16736281080216, 22.33480847306842]).setPopup(popupZeppelinHotDogSKM)
    .addTo(map);

  const blue2 = new mapboxgl.Marker({ color: 'rgb(59, 130, 246)' })
    .setLngLat([114.16665758071588, 22.334950282499662]).setPopup(popupToolss)
    .addTo(map);

  const indigo1 = new mapboxgl.Marker({ color: 'rgb(99, 102, 241)' })
    .setLngLat([114.15809517195748, 22.328221504681693]).setPopup(popupKeiHing)
    .addTo(map);

  const observer = new IntersectionObserver(entries => {

    entries.forEach(entry => {
      const id = entry.target.getAttribute('id');
      console.log(id);

      if (entry.intersectionRatio > 0) {
        document.querySelector(`.index-sticky-nav a[href="#${id}"]`).classList.add('active');
        console.log("on screen");
        console.log(entry.intersectionRatio);
        console.log(entry.boundingClientRect);
      }
      else {
        document.querySelector(`.index-sticky-nav a[href="#${id}"]`).classList.remove('active');
        console.log("off screen");
        console.log(entry.intersectionRatio);
        console.log(entry.boundingClientRect);
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