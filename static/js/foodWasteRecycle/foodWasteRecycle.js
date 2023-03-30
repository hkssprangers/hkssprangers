document.addEventListener("DOMContentLoaded", function () {
  var earthCircle = document.getElementById("earth-circle");

  console.log('vh: ' + screen.height);

  function SetearthCircle(ratio) {
    earthCircle.style.setProperty('width', (screen.height*0.85*ratio) + "px");
    earthCircle.style.setProperty('height', (screen.height*0.85*ratio) + "px");
    earthCircle.style.setProperty('opacity', ratio);
  }

  SetearthCircle(1);

  function handler(entries, observer) {
    for (entry of entries) {
      console.log(entry);
      
      let ratio = entry.intersectionRatio;

      if (ratio >= 1) {
        console.log('on screen ' + ratio);
        SetearthCircle(1-ratio);
      } else if (ratio <= 0) {
        console.log('off screen ' + ratio);
        SetearthCircle(1);
      } else {
        console.log('partial ' + ratio);
        SetearthCircle(1-ratio);
      }
    }
  }

  /* This custom threshold invokes the handler whenever:
    1. The target begins entering the viewport (0 < ratio < 1).
    2. The target fully enters the viewport (ratio >= 1).
    3. The target begins leaving the viewport (1 > ratio > 0).
    4. The target fully leaves the viewport (ratio <= 0).
    Try adding additional thresholds! */
  let observer = new IntersectionObserver(handler, {
    threshold: [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1]
  });
  observer.observe(document.getElementById("section-earth"));
});