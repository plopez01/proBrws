void mouseClicked() {
  if (mouseY < navBar.size) {
    navBar.focus = true;
  } else {
    navBar.focus = false;
  }
}

void keyPressed() {
  if (navBar.focus) {
    if(key == ''){ // I know, this is like the most hackiest thing ever and idk if will work in other os than windows. Let's just leave it for now ;)
      //Ctrl-v
      navBar.text += GetTextFromClipboard();
      return;
    }
    switch(keyCode) {
    case 8:
      if (navBar.text.length() != 0) {
        navBar.text = navBar.text.substring(0, navBar.text.length()-1);
      }
      break;

    case 10:
      navBar.focus = false;
      search(navBar.text);
      break;

    default:
      if (keyCode > 31) navBar.text += key;
      break;
    }
  }
}
