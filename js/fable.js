// Initialize CodeMirror
const editor = CodeMirror.fromTextArea(document.getElementById("code-editor"), {
    mode: "ocaml",
    theme: "monokai",
    lineNumbers: true,
    indentUnit: 2,
    tabSize: 2,
    lineWrapping: true
});

// Example stories
const examples = {
    simple: `(* A simple story with multiple scenes *)
    let story = {
        title = "The Magic Forest";
        start = "forest_entrance";
        scenes = [
            {
                id = "forest_entrance";
                text = "You stand at the entrance of a magical forest. The trees seem to whisper secrets.";
                choices = [
                    { text = "Enter the forest"; next = "forest_path" }
                ]
            },
            {
                id = "forest_path";
                text = "The path winds through ancient trees. Sunlight filters through the leaves.";
                choices = [
                    { text = "Continue deeper"; next = "forest_clearing" }
                ]
            }
        ]
    }`,

    choices: `(* A story with multiple choices *)
    let story = {
        title = "The Mysterious Cave";
        start = "cave_entrance";
        scenes = [
            {
                id = "cave_entrance";
                text = "A dark cave looms before you. Strange sounds echo from within.";
                choices = [
                    { text = "Enter cautiously"; next = "cave_interior" },
                    { text = "Look for a torch"; next = "find_torch" }
                ]
            },
            {
                id = "cave_interior";
                text = "The cave is pitch black. You can barely see your hand in front of your face.";
                choices = [
                    { text = "Feel your way forward"; next = "cave_deep" },
                    { text = "Go back outside"; next = "cave_entrance" }
                ]
            }
        ]
    }`,

    variables: `(* A story with variables *)
    let story = {
        title = "The Treasure Hunt";
        start = "beach_start";
        variables = ["coins", "map"];
        scenes = [
            {
                id = "beach_start";
                text = "You find a treasure map on the beach. Your coin purse jingles with 10 gold coins.";
                choices = [
                    { text = "Follow the map"; next = "jungle_path" }
                ]
            },
            {
                id = "jungle_path";
                text = "The map leads you to a jungle path. A merchant offers to buy your map for 5 coins.";
                choices = [
                    { text = "Sell the map"; next = "merchant_deal" },
                    { text = "Keep the map"; next = "keep_map" }
                ]
            }
        ]
    }`
};

// Load an example into the editor
function loadExample(name) {
    editor.setValue(examples[name]);
}

// Run the story
function runStory() {
    const code = editor.getValue();
    const output = document.getElementById("story-output");
    output.innerHTML = "<div class=\"story-text\">Loading story...</div>";
    
    try {
        const story = parseStory(code);
        displayStory(story);
    } catch (error) {
        output.innerHTML = `<div class="story-text text-danger">Error: ${error.message}</div>`;
    }
}

// Mock story parser
function parseStory(code) {
    // This is a very simple parser that just extracts the story structure
    // In a real implementation, this would be much more sophisticated
    const story = {
        title: "Demo Story",
        currentScene: "start",
        scenes: {
            start: {
                text: "This is a demo of the Fable interactive storytelling system.",
                choices: [
                    { text: "Continue", next: "scene1" }
                ]
            },
            scene1: {
                text: "You can write your own stories using the Fable DSL!",
                choices: [
                    { text: "Learn More", next: "end" }
                ]
            },
            end: {
                text: "Check out the example stories to see what you can create!",
                choices: []
            }
        }
    };
    return story;
}

// Display the story
function displayStory(story) {
    const output = document.getElementById("story-output");
    const scene = story.scenes[story.currentScene];
    
    let html = `<div class="story-text">${scene.text}</div>`;
    
    if (scene.choices && scene.choices.length > 0) {
        html += "<div class=\"choices\">";
        scene.choices.forEach(choice => {
            html += `<button class="story-choice" onclick="makeChoice(\"${choice.next}\")">${choice.text}</button>`;
        });
        html += "</div>";
    }
    
    output.innerHTML = html;
}

// Handle choice selection
function makeChoice(nextScene) {
    const story = {
        currentScene: nextScene,
        scenes: {
            scene1: {
                text: "You chose to continue the story!",
                choices: [
                    { text: "Go back", next: "start" }
                ]
            }
        }
    };
    displayStory(story);
}

// Load the simple example by default
loadExample("simple");
