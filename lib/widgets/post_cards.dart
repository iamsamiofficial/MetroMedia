import 'package:flutter/material.dart';
import 'package:metro_media/utils/colors.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
  final snap;
  const PostCard({ Key? key ,required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
      
          //Header Section

          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                 children: [
                    CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(
                      snap['profImage'],
                      //snap['profImage'],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:  [
                            Text(
                              snap["username"],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  DateFormat.yMMMd().format(snap['datePublished'].toDate()),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: secondaryColor,
                                    ),
                                  ),
                                ),

                          ],
                        ),
                      ),
                      ),
                      IconButton(
                        onPressed: (() {
                          showDialog(
                            context: context, builder:(context)=> Dialog(
                            child: ListView(
                              padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 16),
                              shrinkWrap: true,
                              children: [
                                "Delete",
                              ]
                              .map((e) => InkWell(
                                onTap: (){},
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 16),
                                  child:Text(e) ,
                                ),
                              ),).toList(),
                            ),
                          ));
                        }),
                        icon: const Icon(Icons.more_vert),
                        ),

                 ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                            '${snap["description"]}',
                            style:const TextStyle(color: primaryColor),
                          ),
                ),

              ],
            ),

          ),
          //Image Section
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            //child: Image.network(   //'${snap['likes'].length} likes'
             child: Image.network('${snap['postUrl']}',   //'${snap['likes'].length} likes'
            fit: BoxFit.cover,
            ),
          ),

        //Like and Comment Section
        Row(
          children: [
            IconButton(
          onPressed: (){},
          icon: const Icon(
            Icons.favorite,
            color: Colors.red,
            ),
        ),
        IconButton(
          onPressed: (){},
          icon: const Icon(
            Icons.comment_outlined,
            
            ),
        ),
        IconButton(
          onPressed: (){},
          icon: const Icon(
            Icons.send,
            
            ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomRight,
            child: IconButton(onPressed: (){}, icon: const Icon(Icons.bookmark_border),),),
          ),
      ],
        ),
        //Description and Number of Comments
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child:Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultTextStyle(
                style: Theme.of(context).textTheme.subtitle2!.copyWith(fontWeight: FontWeight.bold),
                child: Text(
                '${snap['likes'].length} likes',
                style: Theme.of(context).textTheme.bodyText2,
                ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    
                    text: TextSpan(
                      style: const TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                          text: snap['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // TextSpan(
                        //   text: ' ${snap["description"]}',
                        // ),
                      ]
                    ),
                    ),
                ),
                InkWell(
                  onTap: (){},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      "View all 150 comments",
                    style: TextStyle(
                      fontSize: 16,
                      color: secondaryColor,
                      ),
                      ),
                  ),
                ),
                // Container(
                //     padding: const EdgeInsets.symmetric(vertical: 4),
                //     child: Text(
                //       DateFormat.yMMMd().format(snap['datePublished'].toDate()),
                //     style: TextStyle(
                //       fontSize: 16,
                //       color: secondaryColor,
                //       ),
                //       ),
                //   ),
            ],
          ),
        ),
        ],
      ),
    );
  }
}