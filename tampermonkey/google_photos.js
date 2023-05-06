// ==UserScript==
// @name         Click 50px from Top-Right Corner on Delete Key Press
// @version      1.0
// @description  Simulates clicks 50px from the top-right corner of the screen whenever the delete key is pressed on Google Photos website
// @match        https://photos.google.*
// ==/UserScript==

(function() {
  // Select the document body
  const body = document.querySelector('body');

  // Attach an event listener to the document body for the 'keydown' event
  body.addEventListener('keydown', function(event) {
    // Check if the delete key was pressed
    if (event.code === 'Delete') {
      // Calculate the coordinates of the top-right corner of the screen
      const screenWidth = window.innerWidth;
      const screenHeight = window.innerHeight;
      const topRightX = screenWidth - 50;
      const topRightY = 50;

      // Simulate a click event at 50px in each direction from the top right corner
      const event1 = new MouseEvent('click', {
        clientX: topRightX - 50,
        clientY: topRightY - 50,
      });
      document.dispatchEvent(event1);
    }
  });
})();
