import 'dart:convert';

class Uploader {
	String? login;
	int? id;
	String? nodeId;
	String? avatarUrl;
	String? gravatarId;
	String? url;
	String? htmlUrl;
	String? followersUrl;
	String? followingUrl;
	String? gistsUrl;
	String? starredUrl;
	String? subscriptionsUrl;
	String? organizationsUrl;
	String? reposUrl;
	String? eventsUrl;
	String? receivedEventsUrl;
	String? type;
	bool? siteAdmin;

	Uploader({
		this.login, 
		this.id, 
		this.nodeId, 
		this.avatarUrl, 
		this.gravatarId, 
		this.url, 
		this.htmlUrl, 
		this.followersUrl, 
		this.followingUrl, 
		this.gistsUrl, 
		this.starredUrl, 
		this.subscriptionsUrl, 
		this.organizationsUrl, 
		this.reposUrl, 
		this.eventsUrl, 
		this.receivedEventsUrl, 
		this.type, 
		this.siteAdmin, 
	});

	@override
	String toString() {
		return 'Uploader(login: $login, id: $id, nodeId: $nodeId, avatarUrl: $avatarUrl, gravatarId: $gravatarId, url: $url, htmlUrl: $htmlUrl, followersUrl: $followersUrl, followingUrl: $followingUrl, gistsUrl: $gistsUrl, starredUrl: $starredUrl, subscriptionsUrl: $subscriptionsUrl, organizationsUrl: $organizationsUrl, reposUrl: $reposUrl, eventsUrl: $eventsUrl, receivedEventsUrl: $receivedEventsUrl, type: $type, siteAdmin: $siteAdmin)';
	}

	factory Uploader.fromMap(Map<String, dynamic> data) => Uploader(
				login: data['login'] as String?,
				id: data['id'] as int?,
				nodeId: data['node_id'] as String?,
				avatarUrl: data['avatar_url'] as String?,
				gravatarId: data['gravatar_id'] as String?,
				url: data['url'] as String?,
				htmlUrl: data['html_url'] as String?,
				followersUrl: data['followers_url'] as String?,
				followingUrl: data['following_url'] as String?,
				gistsUrl: data['gists_url'] as String?,
				starredUrl: data['starred_url'] as String?,
				subscriptionsUrl: data['subscriptions_url'] as String?,
				organizationsUrl: data['organizations_url'] as String?,
				reposUrl: data['repos_url'] as String?,
				eventsUrl: data['events_url'] as String?,
				receivedEventsUrl: data['received_events_url'] as String?,
				type: data['type'] as String?,
				siteAdmin: data['site_admin'] as bool?,
			);

	Map<String, dynamic> toMap() => {
				'login': login,
				'id': id,
				'node_id': nodeId,
				'avatar_url': avatarUrl,
				'gravatar_id': gravatarId,
				'url': url,
				'html_url': htmlUrl,
				'followers_url': followersUrl,
				'following_url': followingUrl,
				'gists_url': gistsUrl,
				'starred_url': starredUrl,
				'subscriptions_url': subscriptionsUrl,
				'organizations_url': organizationsUrl,
				'repos_url': reposUrl,
				'events_url': eventsUrl,
				'received_events_url': receivedEventsUrl,
				'type': type,
				'site_admin': siteAdmin,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Uploader].
	factory Uploader.fromJson(String data) {
		return Uploader.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [Uploader] to a JSON string.
	String toJson() => json.encode(toMap());
}
