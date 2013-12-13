part of fwf;

/**
 * Call this one time in your main() function to initialize all popover menus
 */

class Instruction{
  
  /**
   * Call this one time in your main() function to initialize all popover menus
   */

  Fleet fleetA;
  Fleet fleetB;
  
  void initInstructions() {
    var instructions = querySelectorAll(".instruction");
    for (Element instruction in instructions) {
      var items = querySelectorAll("#${instruction.id} li");
      for (Element item in items) {
        item.onClick.listen((event) {
          hideInstruction(instruction.id);
          instructionAction(instruction.id, item.id);
        });
      }

    }
  }
  
  
  /**
   * Call this function to make a popover menu appear on the screen.
   * You can provide an optional x,y coordinate for the menu.
   */
  void showInstructions(String id, [ num x, num y ]) {
    DivElement instruction = querySelector("#$id");
    if (instruction != null) {
      if (x != null && y != null) {
        instruction.style.left = "${x.toInt() + 50}px";
        instruction.style.top = "${y.toInt() - 55}px";
      }
      instruction.style.visibility = "visible";
      instruction.style.opacity = "1.0";
    }
  }
  
  
  /**
   * Call this function to hide a popover menu
   */
  void hideInstruction(String id) {
    DivElement instruction = querySelector("#$id");
    if (instruction != null) {
      instruction.style.opacity = "0.0";
      new Timer(const Duration(milliseconds : 300), () {
        instruction.style.visibility = "hidden";
      });
    }
  }
  
  
  /**
   * You'll need to implement this function to do stuff when the user selects
   * an item in a popover menu
   */
  void instructionAction(String instruction, String action) {
    //show fleets after click to continue
    game.fleetA.show();
    game.fleetB.show();
    game.transitionActions();
  }
  
}
