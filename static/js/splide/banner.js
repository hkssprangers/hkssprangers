window.onload = function() {
  new Splide( '.splide', {
    type: 'loop',
    autoplay: true,
    interval: 8000,
    perPage: 2,
    perMove: 2,
    padding: {
      left: '10%',
      right: '10%'
    },
    breakpoints: {
      640: {
        perPage: 1,
        perMove: 1,
        padding: {
          left: '10%',
          right: '10%'
        }
      },
    }
  } ).mount();
}

