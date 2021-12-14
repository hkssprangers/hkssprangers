window.onload = function() {
  new Splide( '.splide', {
    type: 'loop',
    autoplay: true,
    interval: 2000,
    perPage: 2,
    perMove: 2,
    padding: {
      left: '10%',
      right: '10%'
    },
    breakpoints: {
      640: {
        padding: {
          left: '0%',
          right: '0%'
        }
      },
    }
  } ).mount();
}

