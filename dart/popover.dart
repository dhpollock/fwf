/*
 * Green Home Games
 *
 * Michael S. Horn
 * Northwestern University
 * michael-horn@northwestern.edu
 * Copyright 2013, Michael S. Horn
 *
 * This project was funded in part by the National Science Foundation.
 * Any opinions, findings and conclusions or recommendations expressed in this
 * material are those of the author(s) and do not necessarily reflect the views
 * of the National Science Foundation (NSF).
 */
part of fwf;

/**
 * Call this one time in your main() function to initialize all popover menus
 */

class Menu{
  
  /**
   * Call this one time in your main() function to initialize all popover menus
   */
  void initPopovers() {
    var popovers = querySelectorAll(".popover");
    for (Element popover in popovers) {
      var items = querySelectorAll("#${popover.id} li");
      for (Element item in items) {
        item.onClick.listen((event) {
          hidePopover(popover.id);
          popoverAction(popover.id, item.id);
        });
      }

    }
  }
  
  
  /**
   * Call this function to make a popover menu appear on the screen.
   * You can provide an optional x,y coordinate for the menu.
   */
  void showPopover(String id, [ num x, num y ]) {
    DivElement popover = querySelector("#$id");
    if (popover != null) {
      if (x != null && y != null) {
        popover.style.left = "${x.toInt() + 50}px";
        popover.style.top = "${y.toInt() - 55}px";
      }
      popover.style.visibility = "visible";
      popover.style.opacity = "1.0";
    }
  }
  
  
  /**
   * Call this function to hide a popover menu
   */
  void hidePopover(String id) {
    DivElement popover = querySelector("#$id");
    if (popover != null) {
      popover.style.opacity = "0.0";
      new Timer(const Duration(milliseconds : 300), () {
        popover.style.visibility = "hidden";
      });
    }
  }
  
  
  /**
   * You'll need to implement this function to do stuff when the user selects
   * an item in a popover menu
   */
  void popoverAction(String popover, String action) {
    //window.alert("$popover, $action");
  }
  
}
