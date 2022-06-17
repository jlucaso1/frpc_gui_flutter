import 'dart:convert';

import 'asset.dart';
import 'author.dart';

class GithubRelease {
  String? url;
  String? assetsUrl;
  String? uploadUrl;
  String? htmlUrl;
  int? id;
  Author? author;
  String? nodeId;
  String? tagName;
  String? targetCommitish;
  String? name;
  bool? draft;
  bool? prerelease;
  String? createdAt;
  String? publishedAt;
  List<Asset>? assets;
  String? tarballUrl;
  String? zipballUrl;
  String? body;

  GithubRelease({
    this.url,
    this.assetsUrl,
    this.uploadUrl,
    this.htmlUrl,
    this.id,
    this.author,
    this.nodeId,
    this.tagName,
    this.targetCommitish,
    this.name,
    this.draft,
    this.prerelease,
    this.createdAt,
    this.publishedAt,
    this.assets,
    this.tarballUrl,
    this.zipballUrl,
    this.body,
  });

  @override
  String toString() {
    return 'GithubRelease(url: $url, assetsUrl: $assetsUrl, uploadUrl: $uploadUrl, htmlUrl: $htmlUrl, id: $id, author: $author, nodeId: $nodeId, tagName: $tagName, targetCommitish: $targetCommitish, name: $name, draft: $draft, prerelease: $prerelease, createdAt: $createdAt, publishedAt: $publishedAt, assets: $assets, tarballUrl: $tarballUrl, zipballUrl: $zipballUrl, body: $body';
  }

  factory GithubRelease.fromMap(Map<String, dynamic> data) => GithubRelease(
        url: data['url'] as String?,
        assetsUrl: data['assets_url'] as String?,
        uploadUrl: data['upload_url'] as String?,
        htmlUrl: data['html_url'] as String?,
        id: data['id'] as int?,
        author: data['author'] == null
            ? null
            : Author.fromMap(data['author'] as Map<String, dynamic>),
        nodeId: data['node_id'] as String?,
        tagName: data['tag_name'] as String?,
        targetCommitish: data['target_commitish'] as String?,
        name: data['name'] as String?,
        draft: data['draft'] as bool?,
        prerelease: data['prerelease'] as bool?,
        createdAt: data['created_at'] as String?,
        publishedAt: data['published_at'] as String?,
        assets: (data['assets'] as List<dynamic>?)
            ?.map((e) => Asset.fromMap(e as Map<String, dynamic>))
            .toList(),
        tarballUrl: data['tarball_url'] as String?,
        zipballUrl: data['zipball_url'] as String?,
        body: data['body'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'url': url,
        'assets_url': assetsUrl,
        'upload_url': uploadUrl,
        'html_url': htmlUrl,
        'id': id,
        'author': author?.toMap(),
        'node_id': nodeId,
        'tag_name': tagName,
        'target_commitish': targetCommitish,
        'name': name,
        'draft': draft,
        'prerelease': prerelease,
        'created_at': createdAt,
        'published_at': publishedAt,
        'assets': assets?.map((e) => e.toMap()).toList(),
        'tarball_url': tarballUrl,
        'zipball_url': zipballUrl,
        'body': body,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [GithubRelease].
  factory GithubRelease.fromJson(String data) {
    return GithubRelease.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [GithubRelease] to a JSON string.
  String toJson() => json.encode(toMap());
}
