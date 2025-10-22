<header>
    <button class="menu-toggle" id="menuToggleBtn">
        <img id="toggleIcon" src="/home-clothing-tester/assets/images/icons/Nav-Menu.png" alt="Menú">
    </button>

    <div class="title-wrapper">
        <h1 class="text-border">HOME CLOTHING TESTER</h1>
        <h1 class="text-fill">HOME CLOTHING TESTER</h1>
    </div>

        <?php if (isset($_SESSION['correo'])): ?>
        <div class="user-email"><?= htmlspecialchars($_SESSION['correo']) ?></div>
    <?php endif; ?>
</header>