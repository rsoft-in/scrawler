# scrawl

<img src="https://raw.githubusercontent.com/rsoft-in/scrawl/main/images/scrawl-playstore.png"/>

A simple notes app with offline and online backup. Uses Nextcloud to store your backup. Assign labels, set colours for notes. Search your notes easily. You can even archive your notes.

## Features
- Supports Android/iOS (iOS not published yet but works fine)
- Search notes
- List/grid view for notes
- Labels for notes
- Archive notes
- Local backup/restore
- Nextcloud backup/restore
- Smooth UI
- AppLock ``` yes, both fingerprint and FaceID works```

## To-do
- [ ] 'scrawl' Cloud Sync
- [ ] Desktop Support
- [ ] Web Support

## Platform
 - Android
 - iOS ```not published```
 - Desktop ```work in progress```
 - Web ```maybe in the future```

### Android 
<a href='https://play.google.com/store/apps/details?id=com.rsoft.bnotes'><img alt='Get it on Google Play' src='https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png' width="200"/></a>

## Compiling the app
Before anything, be sure to have a working flutter sdk setup.If not installed, go to [Install - Flutter](https://docs.flutter.dev/get-started/install).

Be sure to disable signing on build.gradle or change keystore to sign the app.

For now the required flutter channel is master, so issue those two commands before starting building:
```
$ flutter channel master
```
```
$ flutter upgrade
```

After that, building is simple as this:
```
$ flutter pub get
```
```
$ flutter run
```
```
$ flutter build apk
```

## Contributing

Feel free to open a PR to suggest fixes, features or whatever you want, just remember that PRs are subjected to manual review so you gotta wait for actual people to look at your contributions.

## Donate Us

### <a href= "paypal.me/nandanrmenon">PayPal Me!</a>
