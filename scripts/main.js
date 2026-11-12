(function () {
  'use strict';

  var BREAKPOINT = 1024;
  var menuToggle = document.querySelector('.menu-toggle');
  var nav = document.querySelector('.site-nav');

  function isMobile() {
    return window.innerWidth < BREAKPOINT;
  }

  function getSubmenuItems() {
    if (!nav) return [];
    return Array.prototype.slice.call(
      nav.querySelectorAll('.nav-item--has-sub')
    );
  }

  function setSubmenuState(item, open) {
    var button = item.querySelector('.submenu-toggle');
    item.classList.toggle('is-submenu-open', open);
    if (!button) return;

    button.setAttribute('aria-expanded', open ? 'true' : 'false');
    var openLabel = button.getAttribute('data-label-open');
    var closeLabel = button.getAttribute('data-label-close');
    if (open) {
      button.setAttribute(
        'aria-label',
        closeLabel || openLabel || 'Fechar submenu'
      );
    } else {
      button.setAttribute(
        'aria-label',
        openLabel || closeLabel || 'Abrir submenu'
      );
    }
  }

  function closeSubmenus(except) {
    getSubmenuItems().forEach(function (item) {
      if (item !== except) setSubmenuState(item, false);
    });
  }

  function setMenu(open) {
    if (!menuToggle || !nav) return;
    nav.classList.toggle('is-open', open);
    menuToggle.setAttribute('aria-expanded', open ? 'true' : 'false');
    menuToggle.setAttribute(
      'aria-label',
      open ? 'Fechar menu' : 'Abrir menu'
    );
    if (!open) closeSubmenus();
  }

  function firstSubmenuLink(item) {
    return item.querySelector('.submenu a');
  }

  function parentLinkOf(item) {
    var children = item.children;
    for (var i = 0; i < children.length; i += 1) {
      if (children[i].tagName === 'A') return children[i];
    }
    return null;
  }

  if (menuToggle && nav) {
    menuToggle.addEventListener('click', function () {
      setMenu(!nav.classList.contains('is-open'));
    });

    getSubmenuItems().forEach(function (item) {
      var button = item.querySelector('.submenu-toggle');
      var panel = item.querySelector('.submenu');
      var parentLink = parentLinkOf(item);
      if (!button || !panel) return;

      button.setAttribute('aria-haspopup', 'true');

      button.addEventListener('click', function (event) {
        event.preventDefault();
        event.stopPropagation();
        var willOpen = !item.classList.contains('is-submenu-open');
        closeSubmenus(item);
        setSubmenuState(item, willOpen);
      });

      item.addEventListener('focusout', function (event) {
        if (!item.contains(event.relatedTarget)) {
          setSubmenuState(item, false);
        }
      });

      function openAndFocusFirst(event) {
        if (event.key !== 'ArrowDown') return;
        event.preventDefault();
        closeSubmenus(item);
        setSubmenuState(item, true);
        var link = firstSubmenuLink(item);
        if (link) link.focus();
      }

      button.addEventListener('keydown', openAndFocusFirst);
      if (parentLink) {
        parentLink.setAttribute('aria-haspopup', 'true');
        parentLink.addEventListener('keydown', openAndFocusFirst);
      }

      panel.addEventListener('keydown', function (event) {
        var links = Array.prototype.slice.call(panel.querySelectorAll('a'));
        var index = links.indexOf(document.activeElement);

        if (event.key === 'ArrowDown') {
          event.preventDefault();
          var next = links[index + 1] || links[0];
          if (next) next.focus();
        } else if (event.key === 'ArrowUp') {
          event.preventDefault();
          var previous = links[index - 1] || links[links.length - 1];
          if (previous) previous.focus();
        } else if (event.key === 'Home') {
          event.preventDefault();
          if (links[0]) links[0].focus();
        } else if (event.key === 'End') {
          event.preventDefault();
          if (links[links.length - 1]) links[links.length - 1].focus();
        }
      });
    });

    nav.querySelectorAll('a').forEach(function (link) {
      link.addEventListener('click', function () {
        if (isMobile()) setMenu(false);
      });
    });
  }

  document.addEventListener('click', function (event) {
    if (!nav) return;
    if (nav.contains(event.target)) return;
    if (menuToggle && menuToggle.contains(event.target)) return;
    closeSubmenus();
    if (nav.classList.contains('is-open')) setMenu(false);
  });

  document.addEventListener('keydown', function (event) {
    if (event.key !== 'Escape' && event.key !== 'Esc') return;

    var openItem = nav
      ? nav.querySelector('.nav-item--has-sub.is-submenu-open')
      : null;

    if (openItem) {
      var button = openItem.querySelector('.submenu-toggle');
      setSubmenuState(openItem, false);
      if (button) button.focus();
      return;
    }

    if (nav && nav.classList.contains('is-open')) {
      setMenu(false);
      if (menuToggle) menuToggle.focus();
    }
  });

  window.addEventListener('resize', function () {
    if (isMobile()) return;
    if (nav) nav.classList.remove('is-open');
    if (menuToggle) {
      menuToggle.setAttribute('aria-expanded', 'false');
      menuToggle.setAttribute('aria-label', 'Abrir menu');
    }
    closeSubmenus();
  });
})();
