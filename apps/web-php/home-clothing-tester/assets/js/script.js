//Espera hasta HTML esté cargado y listo para ser manipulado, y luego ejecuta esta función
document.addEventListener("DOMContentLoaded", function () {

  // FORMULARIO LOGIN
  const toggleBtn = document.getElementById("showLoginBtn");
  const loginForm = document.getElementById("loginForm");
  const closeBtn = document.getElementById("closeLoginForm");

  if (toggleBtn && loginForm) {

    // Mostrar/Ocultar el formulario
    toggleBtn.addEventListener("click", e => {
      e.preventDefault();
      loginForm.classList.toggle("active");
    });
  }

  if (closeBtn && loginForm) {

    // Cerrar el formulario
    closeBtn.addEventListener("click", () => {
      loginForm.classList.remove("active");
    });
  }

  // Cuando se presiona ESC y el formulario de login está visible, lo oculta.
  document.addEventListener("keydown", function (e) {
    if (e.key === "Escape" && loginForm?.classList.contains("active")) {
      loginForm.classList.remove("active");
    }
  });

  // SIDEBAR TOGGLE (menú lateral)
  const menuToggleBtn = document.getElementById("menuToggleBtn"); // Botón que abre/cierra el menú lateral
  const sidebarMenu = document.getElementById("sidebarMenu");     // Menú lateral
  const toggleIcon = document.getElementById("toggleIcon");       // Icono del menú

  // Ensure toggle icon is always visible - handle potential image load errors
  if (toggleIcon) {
    // If image fails to load, use a text fallback
    toggleIcon.addEventListener("error", function() {
      console.warn("Menu icon failed to load, using fallback");
      this.style.display = "none";
      // Create text fallback
      if (!menuToggleBtn.querySelector(".icon-fallback")) {
        const fallback = document.createElement("span");
        fallback.className = "icon-fallback";
        fallback.textContent = "☰";
        fallback.style.cssText = "font-size: 24px; color: #fff;";
        menuToggleBtn.appendChild(fallback);
      }
    });

    // Force visibility on load
    toggleIcon.style.display = "block";
    toggleIcon.style.visibility = "visible";
    toggleIcon.style.opacity = "1";
  }

  // Si existen los elementos necesarios
  if (menuToggleBtn && sidebarMenu) {

    // Cuando se hace clic en el botón del menú
    menuToggleBtn.addEventListener("click", (e) => {
      e.stopPropagation(); // Prevent event bubbling
      sidebarMenu.classList.toggle("active");
      // Toggle class on button for CSS-based visual feedback (icon rotation)
      menuToggleBtn.classList.toggle("menu-open");

      // Ensure icon remains visible after click
      if (toggleIcon) {
        toggleIcon.style.display = "block";
        toggleIcon.style.visibility = "visible";
        toggleIcon.style.opacity = "1";
      }
    });

    // Si se presiona ESC y el menú está abierto, se cierra
    document.addEventListener("keydown", (e) => {
      if (e.key === "Escape" && sidebarMenu.classList.contains("active")) {
        sidebarMenu.classList.remove("active");
        menuToggleBtn.classList.remove("menu-open");
      }
    });

    // Close sidebar when clicking outside
    document.addEventListener("click", (e) => {
      if (sidebarMenu.classList.contains("active") &&
          !sidebarMenu.contains(e.target) &&
          !menuToggleBtn.contains(e.target)) {
        sidebarMenu.classList.remove("active");
        menuToggleBtn.classList.remove("menu-open");
      }
    });
  }

  // HEADER SCROLL EFFECT
  const header = document.querySelector("header"); // Selecciona la cabecera (header)

  window.addEventListener("scroll", function () {

    // Si se ha hecho scroll más de 30 píxeles
    if (window.scrollY > 30) {
      header?.classList.add("scrolled");           // Agrega una clase para cambiar el estilo
    } else {
      header?.classList.remove("scrolled");        // Quita la clase si vuelve arriba
    }
  });

  // CARRUSEL SLIDE FUNCTION
  window.scrollCarrusel = function (direction) {
    const carrusel = document.getElementById("carrusel"); // Selecciona el contenedor del carrusel
    const scrollAmount = 220;           // Cantidad de píxeles a mover
    if (carrusel) {
      carrusel.scrollBy({
        left: direction * scrollAmount, // -1 para izquierda, 1 para derecha
        behavior: "smooth"              // Movimiento suave
      });
    }
  };
});