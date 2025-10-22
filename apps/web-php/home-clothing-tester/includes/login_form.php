<section id="loginForm" class="login-form-hidden">
    <h3>Iniciar Sesión</h3>
    <button id="closeLoginForm" class="close-btn" aria-label="Cerrar formulario">✖</button>

    <!-- Si hay un error guardado en la sesión (por ejemplo, "usuario incorrecto"), lo muestra como mensaje. -->
    <?php if (isset($_SESSION['login_error'])): ?>
        <p class="error"><?= htmlspecialchars($_SESSION['login_error']) ?></p>
        <?php unset($_SESSION['login_error']); ?>
    <?php endif; ?>

    <!-- Este formulario envía los datos al archivo login.php, que procesa la autenticación. -->
    <form method="POST" action="../../controllers/comunes/login.php">
        <label for="correo_usuario">Correo Usuario:</label>
        <input type="email" name="correo_usuario" id="correo_usuario" required placeholder="Correo Usuario">

        <label for="password">Contraseña:</label>
        <input type="password" name="password" id="password" required placeholder="Contraseña">

        <button type="submit">Entrar</button>
    </form>
</section>