document.addEventListener("DOMContentLoaded", function(){
  mapboxgl.accessToken = 'pk.eyJ1Ijoic3RlbGxhNzExIiwiYSI6ImNrc3p2OXMzMDJnc2Yyd24xZXZ0ZGt4cGQifQ.Vn6lqChhc0FXjQ_WQWnd-w';
  const map = new mapboxgl.Map({
    container: 'map', // container ID
    style: 'mapbox://styles/mapbox/streets-v11', // style URL
    center: [114.16025186047068,22.33114444434112], // starting position [lng, lat]
    zoom: 15 // starting zoom
  });

  // create the popup
const popup1 = new mapboxgl.Popup({ offset: 25 }).setText(
  '89美食'
  );
  
  // create the popup
  const popup2 = new mapboxgl.Popup({ offset: 25 }).setText(
  '喇沙專門店'
  );
  
  // create the popup
  const popup4 = new mapboxgl.Popup({ offset: 25 }).setText(
  '蕃廚'
  );
  
  // create the popup
  const popup5 = new mapboxgl.Popup({ offset: 25 }).setText(
  'HANA SOFT CREAM'
  );
  
  // create the popup
  const popup6 = new mapboxgl.Popup({ offset: 25 }).setText(
  '窩Street'
  );
  
  // create the popup
  const popup7 = new mapboxgl.Popup({ offset: 25 }).setText(
  '標記樂園潮州粉麵菜館'
  );
  
  // create the popup
  const popup8 = new mapboxgl.Popup({ offset: 25 }).setText(
  'Fast Taste SSP'
  );
  
  // create the popup
  const popup9 = new mapboxgl.Popup({ offset: 25 }).setText(
  'Neighbor'
  );
  
  // create the popup
  const popup10 = new mapboxgl.Popup({ offset: 25 }).setText(
  'The Park by Years'
  );
  
  // create the popup
  const popup11 = new mapboxgl.Popup({ offset: 25 }).setText(
  '梅貴緣'
  );
  
  // create the popup
  const popup12 = new mapboxgl.Popup({ offset: 25 }).setText(
  'Poke Go'
  );
  
  // create the popup
  const popup13 = new mapboxgl.Popup({ offset: 25 }).setText(
  'Years'
  );
  
  // create the popup
  const popup14 = new mapboxgl.Popup({ offset: 25 }).setText(
  'Zeppelin Hot Dog'
  );
  
  // create the popup
  const popup15 = new mapboxgl.Popup({ offset: 25 }).setText(
  'Toolss'
  );
  
  // create the popup
  const popup16 = new mapboxgl.Popup({ offset: 25 }).setText(
  '琦興餐廳'
  );
  
  const red1 = new mapboxgl.Marker({ color: 'rgb(239,68,68)' })
  .setLngLat([114.15999719142565,22.331322836819467]).setPopup(popup1)
  .addTo(map);
  
  const red2 = new mapboxgl.Marker({ color: 'rgb(239,68,68)' })
  .setLngLat([114.16018510255412,22.331224492274075]).setPopup(popup2)
  .addTo(map);
  
  const red4 = new mapboxgl.Marker({ color: 'rgb(239,68,68)' })
  .setLngLat([114.16008933227181,22.331250206095916]).setPopup(popup4)
  .addTo(map);
  
  const red5 = new mapboxgl.Marker({ color: 'rgb(239,68,68)' })
  .setLngLat([114.15992709862553,22.33131448514895]).setPopup(popup5)
  .addTo(map);
  
  const red6 = new mapboxgl.Marker({ color: 'rgb(239,68,68)' })
  .setLngLat([114.15980968380086,22.33122676249549]).setPopup(popup6)
  .addTo(map);
  
  const pink1 = new mapboxgl.Marker({ color: 'rgb(236, 72, 153)' })
  .setLngLat([114.16249194087277,22.331307624504262]).setPopup(popup7)
  .addTo(map);
  
  const pink2 = new mapboxgl.Marker({ color: 'rgb(236, 72, 153)' })
  .setLngLat([114.16288103123213,22.331219487568305]).setPopup(popup8)
  .addTo(map);
  
  const yellow1 = new mapboxgl.Marker({ color: 'rgb(245, 158, 11)' })
  .setLngLat([114.15993884998386,22.335030983704257]).setPopup(popup9)
  .addTo(map);
  
  const green1 = new mapboxgl.Marker({ color: 'rgb(5, 150, 105)' })
  .setLngLat([114.16393714588742,22.32790793020368]).setPopup(popup10)
  .addTo(map);
  
  const green2 = new mapboxgl.Marker({ color: 'rgb(5, 150, 105)' })
  .setLngLat([114.16299112236447,22.328139918152658]).setPopup(popup11)
  .addTo(map);
  
  const green3 = new mapboxgl.Marker({ color: 'rgb(5, 150, 105)' })
  .setLngLat([114.162689501356,22.327606976092454]).setPopup(popup12)
  .addTo(map);
  
  const greenn1 = new mapboxgl.Marker({ color: 'rgb(52, 211, 153)' })
  .setLngLat([114.16075597211704,22.332666679934732]).setPopup(popup13)
  .addTo(map);
  
  const blue1 = new mapboxgl.Marker({ color: 'rgb(59, 130, 246)' })
  .setLngLat([114.16736281080216,22.33480847306842]).setPopup(popup14)
  .addTo(map);
  
  const blue2 = new mapboxgl.Marker({ color: 'rgb(59, 130, 246)' })
  .setLngLat([114.16665758071588,22.334950282499662]).setPopup(popup15)
  .addTo(map);
  
  const indigo1 = new mapboxgl.Marker({ color: 'rgb(99, 102, 241)' })
  .setLngLat([114.15809517195748,22.328221504681693]).setPopup(popup16)
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
      else
      {
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
   for(var i=0;i<howStep.length;i++){
        howStep[i].onclick = function(e){
          thisStep = e.target.getAttribute('data-num');

          howStep.forEach((step) => {
            step.classList.remove('active','bg-white');
            step.classList.add('text-white','font-bold');
          });
          howStep[thisStep].classList.remove('text-white','font-bold');
          howStep[thisStep].classList.add('active','bg-white');

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