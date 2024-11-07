import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math';


class DockerAnimation extends StatefulWidget {
  @override
  _DockerAnimationState createState() => _DockerAnimationState();
}

class _DockerAnimationState extends State<DockerAnimation> {


  List<String> imageUrls = [
    "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c9/Finder_Icon_macOS_Big_Sur.png/600px-Finder_Icon_macOS_Big_Sur.png?20200704175319",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8d/Safari_2020_logo.svg/640px-Safari_2020_logo.svg.png",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/d/da/L%C3%96VE_macOS_app_icon_%280.10.1%29.png/640px-L%C3%96VE_macOS_app_icon_%280.10.1%29.png",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f7/Podcasts_%28macOS%29.png/640px-Podcasts_%28macOS%29.png",
    "https://www-assets.kolide.com/assets/inventory/device_properties/icons/app-schemes-1d02fb4820c8bd23c692637ba24bf60ffb20cb08.png",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/1/15/Skim_Mac_icon.png/640px-Skim_Mac_icon.png",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRsxNDMTTFp74Liv5zO1ykIdVllJj5tQRVnTw&s",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlqNTO28NYu-5pIG3ErxQYWF5Sdbh8BXJGdw&s"
  ];

  int? _hoverIndex;
  int? _draggingIndex;
  int? _potentialDropIndex;

  double maxScale = 1.3;
  double minScale = 0.8;
  double scaleDistanceFactor = 0.3;

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.network(
              'https://i0.wp.com/9to5mac.com/wp-content/uploads/sites/6/2024/10/apple-event-header.jpg?resize=1200%2C628&quality=82&strip=all&ssl=1',
              fit: BoxFit.cover,
            ),
          ),

          // Blurred Dock Background
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                  child: Container(
                    height: 80,
                    width:80.0*8, // Width of dock container
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(imageUrls.length, (index) {
                  return _buildDraggableIcon(context, index);
                }),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDraggableIcon(BuildContext context, int index) {
    return DragTarget<int>(
      onAccept: (draggedIndex) {
        setState(() {
          _swapIcons(draggedIndex, index); // Swap images when dropped
        });
      },
      onWillAccept: (data) {
        setState(() {
          _potentialDropIndex =
              index; // Mark potential drop index for animation
        });
        return data != index; // Prevent drop on the same position
      },
      onLeave: (_) {
        setState(() {
          _potentialDropIndex =
          null; // Reset potential drop index when drag leaves
        });
      },
      builder: (context, candidateData, rejectedData) {
        return MouseRegion(
          onEnter: (_) {
            setState(() {
              _hoverIndex = index; // Set the hovered icon's index
            });
          },
          onExit: (_) {
            setState(() {
              _hoverIndex = null; // Reset when the mouse exits the icon
            });
          },
          child: Draggable<int>(
            data: index,
            onDragStarted: () {
              setState(() {
                _draggingIndex = index; // Set the dragging icon index
              });
            },

            onDragUpdate: (details) {},
            onDragCompleted: () {
              setState(() {
                _draggingIndex = null; // Reset dragging index after completion
                _potentialDropIndex = null; // Reset potential drop index
              });
            },
            onDraggableCanceled: (velocity, offset) {
              setState(() {
                _draggingIndex = null; // Reset when drag is canceled
                _potentialDropIndex = null;
              });
            },
            feedback: _buildImage(
                imageUrls[index], true, index), // Show scaled image during drag
            childWhenDragging: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: _draggingIndex == index
                  ? 0
                  : 60, // Shrink size to 0 when dragging
              height: 60,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: _buildImage(imageUrls[index], false,
                  index), // Show faded image when dragging
            ),
            child: _buildImage(
                imageUrls[index], false, index), // Show normal image
          ),
        );
      },
    );
  }

  Widget _buildImage(String imageUrl, bool isDragging, int index) {
    double scale = _calculateScale(index);

    if (isDragging) {
      scale = 1.5;
    }

    double additionalWidth =
    (_potentialDropIndex != null && index == _potentialDropIndex)
        ? 40.0
        : 0.0;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: 60.0 + additionalWidth,
      height: 60.0,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: AnimatedScale(
        scale: scale,
        duration: Duration(milliseconds: 300),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl,
              width: MediaQuery.of(context).size.width * 0.08,
              height: MediaQuery.of(context).size.width * 0.08,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ),
    );
  }

  double _calculateScale(int index) {
    if (_hoverIndex == null) return 1.0;

    int diff = (index - _hoverIndex!).abs();

    if (diff == 0) {
      return maxScale;
    } else {
      return max(maxScale - scaleDistanceFactor * diff, minScale);
    }
  }

  // Function to swap images
  void _swapIcons(int oldIndex, int newIndex) {
    setState(() {
      String temp = imageUrls[oldIndex];
      imageUrls[oldIndex] = imageUrls[newIndex];
      imageUrls[newIndex] = temp;
    });
  }
}
