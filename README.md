# Crowdbased Help Facilites

# Abstract
This repository explores Crowdbased Help Facilites in the Godot Engine. More concrete I explore two ideas: An Enhanced Tool-Tip and a Crowdbased Tip of the Day (ToD). Both ideas are implemented in the [Godot Engine](https://godotengine.org/) as an Editor Plugin.

# Enhanced Tool-Tip

A Tool-Tip normally consists of a short description of a item the user is hovering over. I enhance the Tool-Tip to reference additional information, like a blogpost or a video, as well as a rating system to further manage and improve the tool.

Here is a UI Mockup.

| ![Enhanced Tool-Tip with Color](Documentation/ToolTip_Prototype_w_C.png)  | 
|:--:| 
| *Mockup of the Enhanced Tool-Tip with a Blog and Video Button in Color* |

A Tool-Tip is a tip that appears inside a Pop-Up window, while a user hovers over an UI object. It contains a short description of the element and disappears when the cursor leaves the object’s space. The Enhanced Tool-Tip is an enhanced version of a Tool-Tip. It appears while hoverin gover a game object. It contains the name of the object, a short description and multiple buttons. The blog and the video buttons lead to additional information sources, when pressed and the like and the dislike buttons enable the user to rate the tip. The Enhanced Tool-Tip generates a database entry, when created. This entry saves and updates the rating.

https://user-images.githubusercontent.com/58075579/127537595-ab79da45-d718-4830-9736-8a90ca51b551.mp4

# Custom Node Plugin

The Enhanced Tool-Tip was implemented as an Editor-plugin, more particular a Custom Node plugin. Any game object inside Godot consists of basic components, called Nodes. Nodes can be added to other Nodes as children. Composing a group of Nodes in a hierarchically tree-like structure results in a scene. Scenes can be instantiated as a child of another scene, leading to complex [game worlds](https://docs.godotengine.org/en/stable/getting_started/step_by_step/scenes_and_nodes.html\#). Just like with Nodes, the engine allows scenes to be added to a game object as a component.
The Custom Node plugin allows a scene with complex behavior to be wrapped in a [custom type Node](https://docs.godotengine.org/en/stable/tutorials/plugins/editor/making_plugins.html\#a-custom-node). This extends the pool of Nodes and makes them easy to access and to use.
In my case, the Enhanced Tool-Tip scene was wrapped inside a custom type Node and can be accessed through the ‘Create New Node‘ panel, which allows to attache a new Node to a game object.

# Crowdbased Tip of the Day (ToD)

A ToD is typically a Pop-Up window displayed when the software starts. It contains a tip for the user, explaining an advanced feature to improve the understanding of the software. I extend the ToD to support the involvement of the crowd, enabling them to commit their own tip and ratetips of others, as well as the recommendation of tips.

| ![Crowdbased Tip of the Day with Color](Documentation/ToDwColor.png) |
|:--:| 
| *Mockup of the Crowdbased Tip of the Day with Color* |

A ToD is typically displayed at the start of the software. It contains a title and a description of a feature of a software, that is not self-explanatory. It has a ‘Close’ and a ‘X’ button, that close the window, as well as a ‘Previous’ and ‘Next’ button to cycle through tips. ToDs typically come from the software creators and are shown in a more or less random order. The Community ToD is like a ToD, but comes from the community. It is displayed in its own screen space. Similar to the Enhanced Tool-Tip it contains additional buttons, like the blog and video buttons, linking to additional information, as well as the like and dislike buttons to rate the tip. Instead of a predefined subset of ToDs from the software creator, users can commit their own tips to control what is shown and can like and dislike tips to control what is shared.

https://user-images.githubusercontent.com/58075579/127538182-45076cab-51a9-413f-8da9-8273ac9a2000.mp4

# Main Screen Plugin

The Community ToD was implemented as a Main Screen plugin, a subtype of an Editor-plugin. This kind of plugin extends the editors interface and allows to create new UIs in the [central part of the editor](https://docs.godotengine.org/en/stable/tutorials/plugins/editor/making_main_screen_plugins.html).
A ‘Community ToD‘ tab is added and appears next to the default ‘2D‘, ‘3D‘, ‘Script‘ and ‘AssetLib‘ tabs. When the ‘Community ToD‘ tab is selected, it displays the Tip scene. This newly added tab works just like the other Main Screens. It can be easily switched between. these tabs. Pressing the ‘X‘ or ‘Close‘ button in the Tip scene disables the plugin, therefore hiding the tab.
