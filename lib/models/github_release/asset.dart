import 'dart:convert';

import 'uploader.dart';

class Asset {
	String? url;
	int? id;
	String? nodeId;
	String? name;
	String? label;
	Uploader? uploader;
	String? contentType;
	String? state;
	int? size;
	int? downloadCount;
	String? createdAt;
	String? updatedAt;
	String? browserDownloadUrl;

	Asset({
		this.url, 
		this.id, 
		this.nodeId, 
		this.name, 
		this.label, 
		this.uploader, 
		this.contentType, 
		this.state, 
		this.size, 
		this.downloadCount, 
		this.createdAt, 
		this.updatedAt, 
		this.browserDownloadUrl, 
	});

	@override
	String toString() {
		return 'Asset(url: $url, id: $id, nodeId: $nodeId, name: $name, label: $label, uploader: $uploader, contentType: $contentType, state: $state, size: $size, downloadCount: $downloadCount, createdAt: $createdAt, updatedAt: $updatedAt, browserDownloadUrl: $browserDownloadUrl)';
	}

	factory Asset.fromMap(Map<String, dynamic> data) => Asset(
				url: data['url'] as String?,
				id: data['id'] as int?,
				nodeId: data['node_id'] as String?,
				name: data['name'] as String?,
				label: data['label'] as String?,
				uploader: data['uploader'] == null
						? null
						: Uploader.fromMap(data['uploader'] as Map<String, dynamic>),
				contentType: data['content_type'] as String?,
				state: data['state'] as String?,
				size: data['size'] as int?,
				downloadCount: data['download_count'] as int?,
				createdAt: data['created_at'] as String?,
				updatedAt: data['updated_at'] as String?,
				browserDownloadUrl: data['browser_download_url'] as String?,
			);

	Map<String, dynamic> toMap() => {
				'url': url,
				'id': id,
				'node_id': nodeId,
				'name': name,
				'label': label,
				'uploader': uploader?.toMap(),
				'content_type': contentType,
				'state': state,
				'size': size,
				'download_count': downloadCount,
				'created_at': createdAt,
				'updated_at': updatedAt,
				'browser_download_url': browserDownloadUrl,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Asset].
	factory Asset.fromJson(String data) {
		return Asset.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [Asset] to a JSON string.
	String toJson() => json.encode(toMap());
}
