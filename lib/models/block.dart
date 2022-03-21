import 'dart:convert';

Block blockFromJson(String str) => Block.fromJson(json.decode(str));

String blockToJson(Block data) => json.encode(data.toJson());

class Block {
  Block({
    required this.blockId,
    required this.name,
  });

  int blockId;
  String name;

  factory Block.fromJson(Map<String, dynamic> json) => Block(
    blockId: json["blockId"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "blockId": blockId,
    "name": name,
  };
}