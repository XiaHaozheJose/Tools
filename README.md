# Tools
# Swifts Tools 

Are all the extension, You don't need to import any classes

### For example
##### 1. Color
```
let randomColor = UIColor.randomColor()
let hexColor = UIColor.randomColor("#ffffff")
let rgb = UIColor.red.getRGBWithColor() 
```

##### 2. String cryption 
# Tools
Swifts Tools 

Are all the extension, You don't need to import any classes

### For example
##### 1. Color
```
let randomColor = UIColor.randomColor()
let hexColor = UIColor.randomColor("#ffffff")
let rgb = UIColor.red.getRGBWithColor() 
```

##### 2. String cryption 
```
To note here, need to cooperate with OC, we create a OC any file, Xcode will prompt us to generate a bridge - Bridging - the Header file XXX. H, here we need # import < CommonCrypto/CommonCrypto.h>, Command + B compiler through. Complete
```
Now you can use it easily

```
let md5 = "password".getMd5()
let sha1 = "password".getSha1()
```
##### 3. UIImage

```
let redImage = UIImage.imageWithColor(color: .red)

let customSizeImage = UIImage(named: "image").imageWithNewSize(size: mySize)

let cycleImage = UIImage(named: "image")?.clipToCycle(withBorder: 1, withColor: .red)

```

##### 4. UIView

```
"alert like android toast"
view.showToast(withString: "I'm a toast", 1.5, 2.5)

```

##### 5. NSObject

```
let cachePath = cacheDir()
        let documentPath = documentDir()
        let tempPath = tempDir()
        
        getDirectoryCache(path) { (size) in
            // get all the file sizes through the path
        }
        
        cleanFolder(path) { (completed) in
            // remove all files by the path
        }
```

##### 6. UIControl

```
"Refresh For TableView , CollectionView O ScrollView"
 let refresh = JSRefreshControl()
 tableView.addSubview(refresh)
refresh.addTarget(self, action: #selector(your function), for: .valueChanged)

"now you can to refresh"
refresh.beginRefreshing()
refresh.endRefreshing()

```

##### 7. More Extension

```
There will be more, if you have time
```



