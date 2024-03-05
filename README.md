Author : Qosim Ariqoh Daffa

NPM : 2006522820

Source : https://github.com/CSUI-Game-Development/tutorial-4-template

Godot Version : 3.5

---

# Latihan Mandiri: Membuat Level Baru Dengan Tile Map & Obstacle Berbeda

Sebagai bagian dari latihan mandiri, kamu diminta untuk praktik membuat level baru yang berbeda dari level pertama. Kebutuhan minimum yang harus diimplementasikan pada level baru:

-   [x] Level menggunakan tile map yang berbeda dari level pertama.
-   [x] Terdapat spawner rintangan di level baru yang membuat objek berbeda dari ikan.
-   [x] Memiliki rintangan berupa jurang dan objek yang berjatuhan secara periodik.

Silakan berkreasi lebih lanjut untuk membuat level baru kamu makin menarik! Jangan lupa untuk menjelaskan proses pengerjaan level baru ini di dalam sebuah dokumen teks README.md. Cantumkan juga referensi-referensi yang digunakan sebagai acuan ketika menjelaskan proses implementasi.

---

## Penambahan tile map berbeda

Penerapan menggunakan tile set yang telah dibuat sebelumnya, dengan melakukan proses yang serupa untuk _spritesheets_ dirt, planet, sand, snow, dan stone. Apabila telah terimplementasi, tile map yang menggunakan tile set ini dapat memilih antara keenam _spritesheets_ tersebut (dirt, grass, planet, sand, snow, dan stone) pada level yang ingin dibuat.

Step-by-step yang perlu dilakukan untuk membuat tile set baru adalah:

1. Pada `Tile Set`, klik `Add texture` dibagian kiri bawah tab `Tile Set`. Lalu, pilih SpriteSheets yang sesuai.
2. Kemudian klik `+ New Atlas` dan drag area dari seluruh SpriteSheets.
3. Ubah `TileSetEditorContent Name` sesuai yang diinginkan dan ubah `Subtile Size` menjadi (128, 128) untuk membagi area tile yang dipilih saat `+ New Atlas` menjadi beberapa subtile dengan ukuran tersebut.
4. Dari subtile-subtile tersebut, buat area `Collision` supaya `Player` dapat _collide_ dengan Tile Set tersebut.
5. Texture baru dari `Tile Set` sudah dapat digunakan di `Tile Map` pada level.

## Repeatable Background

### Implementasi

reference: [How to Make an Infinite Scrolling Background](https://forum.godotengine.org/t/how-to-make-an-infinite-scrolling-background/24114/3)

Pada `Level1`, ditambahkan sebuah background `colored_land.png` pada `TextureRect`. Supaya background tersebut dapat diperpanjang secara horizontal dan berulang, pada atribut `TextureRect` set `Stretch Mode` menjadi **"Tile"**. Hasil pengulangan dapat terlihat ketika ukuran `TextureRect` tersebut diperpanjang, terutama ketika diperpanjang kebawah akan menampilkan kembali bagian langit dari background `colored_land.png`. Implementasi ini juga digunakan pada gambar laut (yang digunakan sebagai area kalah dari pemain).

Kemudian supaya background `colored_land.png` dapat terlihat seperti background yang jauh dari `Player`, yang ditandai dengan pergerakan yang lambat, digunakan _node_ `ParallaxLayer`. Kecepatan _motion_ dari background dapat diatur dengan atribut `Scale` dengan nilai kurang dari satu (1) sehingga kecepatan dari background diperlambat. Untuk menggunakan _node_ `ParallaxLayer`, diperlukan _node_ `ParallaxBackground` sebagai _parent node_-nya. [`ParallaxBackground`](https://docs.godotengine.org/en/3.5/classes/class_parallaxbackground.html) memanfaatkan satu atau lebih `ParallaxLayer` untuk membuat _parallax effect_ pada background, seperti apabila ingin memiliki beberapa objek background yang berbeda yang memiliki kecepatan _motion_ berbeda juga.

```
ParallaxBackground
- ParallaxLayer
- - TextureRect
```

### Improve Reusability

`ParallaxBackground` yang telah dibuat sebelumnya dapat dibuat menjadi _scene_ sehingga dapat di*reuse*. Supaya _texture_ dari _scene_ tersebut dapat diubah sesuai dengan level yang ada, ditambahkan _script_ pada `ParallaxBackground`.

```
extends ParallaxBackground


var texture_rect : TextureRect

export var rectSizeX : int = 1024
export var texture : Texture = load("res://assets/kenney_platformerpack/PNG/Backgrounds/colored_land.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	texture_rect  = get_node("ParallaxLayer/TextureRect")
	texture_rect.texture = texture
	texture_rect.rect_size.x = rectSizeX
	pass # Replace with function body.
```

_By default_, `ParallaxBackground` akan menampilkan `colored_land`. Dengan ditambahkan `export`, `ParallaxBackground` dapat diupdate atribut _texture_ tersebut yang akan diupdate ketika menjalankan _level_ tersebut. Kemudian untuk mengubah panjang dari `TextureRect`, disediakan rectSizeX untuk menyesuaikan panjang dari _background_ sesuai dengan panjang _level_ yang dibuat.

### Changeable Background

Pada `Level3`, ingin melakukan percobaan untuk mengubah _texture_ pada `ParallaxBackground`. Untuk melakukannya perlu ditambahkan `Area2D` dan `CollisionShape` yang kemudian dihubungkan fungsi `_body_entered()` untuk mengubah _texture_ ketika `Player` melaluinya.

```
onready var texture_rect : TextureRect = get_parent().get_node("ParallaxBackground/ParallaxLayer/TextureRect")

func _on_ChangeBackgroundArea_body_entered(body):
	if body.get_name() == "Player":
		texture_rect.texture = load("res://assets/kenney_platformerpack/PNG/Backgrounds/colored_shroom.png")
```

Pada _node_ `Area2D` yang dinamakan `ChangeBackgroundArea`, dipanggil `TextureRect` secara _hardcode_ yang dimaksud dari *parent*nya.
Kemudian _textre_ pada `TextureRect` diupdate dengan _path texture_ yang baru.

---

## Implementasi new mob (obstacle)

### FallingFish

#### Update Pengembangan FallingFish

Sebelumnya dilab, terjadi suatu masalah dimana _node_ `FallingFish` yang dibuat tidak mentrigger _signal_ `_body_entered()` yang dimana bermaksud untuk memberikan sinyal ketika `Player` menyentuh `FallingFish`. Solusi yang ditemukan oleh **Ivan Rabbani C.** dari group Discord GameDev adalah dengan memberikan mengatur atribut `Contacts Report` menjadi > 0 dan `Contacts Monitor` menjadi `true`. Setelah dilakukan proses tersebut, _node_ `RigidBody2D` yang dimiliki oleh `FallingFish` akhirnya dapat mengirimkan sinyal ketika terjadi _collision_ dengan objek lain.

Namun, `FallingFish` masih memberikan _bug_, yaitu `FallingFish` akan menghilangkan _platform_ (atau lebih tepatnya `TileMap`) yang telah dibuat dari `Level1`. Masalah ini bisa terjadi dikarenakan implementasi handle sinyal berdasarkan web tutorial 4 gamedev.

```
func _on_FallArea_body_entered(body):
    if body.get_name() == "Player":
        get_tree().change_scene(str("res://scenes/" + sceneName + ".tscn"))
    else:
        body.queue_free()
```

[`queue_free()`](https://docs.godotengine.org/en/3.5/classes/class_node.html#class-node-method-queue-free) merupakan sebuah fungsi yang dimiliki oleh `Node` untuk menghilangkan _node_ tersebut dari _frame_. Berdasarkan kode diatas, _node_ yang dihilangkan adalah `body` yang dimana berarti objek yang menyentuh `FallingFish`. Sehingga apabila `FallingFish` menyentuh _platform_ dan objek selain `Player`, objek tersebut akan dihapus.

Solusi yang dapat dilakukan adalah dengan mengubah `body.queue_free()` menjadi `self.queue_free()` sehingga yang terhapus adalah _node_ `FallingFish`.

```
func _on_FallArea_body_entered(body):
    if body.get_name() == "Player":
        get_tree().change_scene(str("res://scenes/" + sceneName + ".tscn"))
    else:
        self.queue_free()
```

#### Change Texture upon Death

Solusi diatas dapat dikembangkan lebih lanjut dengan mengubah _texture_ dari `FallingFish` menjadi versi _death_-nya dan memberikan waktu sebelum dihilangkan.

```
func _on_RigidBody2D_body_entered(body):
	print(body.get_name())
	if body.get_name() == "Player":
		get_tree().change_scene(str("res://scenes/" + sceneName + ".tscn"))
	else:
		get_node("Sprite").frame_coords.y = 3
		yield(get_tree().create_timer(3), "timeout")
		self.queue_free()
```

`frame_coord` untuk _texture_ fish versi normal adalah (3,2), sedangkan versi *death*nya adalah (3,3).

### JumpingFish

#### Implementation

Implementasi yang dilakukan kurang lebih sama dengan `FallingFish` untuk pergerakan jatuh dan *lose condition*nya. Berbedaan terletak pada `func _process()` untuk pergerakan lompat keatas dengan mengurangi nilai `linear_velocity.y`, yang merupakan kecepatan pergerakan pada _node_ `RigidBody2D`. Kemudian dilakukan juga `update_animation()` untuk mengubah _frame_ dari `JumpingFish` supaya yang tadinya menghadap keatas, jadi menghadap kebawah ketika sedang jatuh.

```
export var maxHeight : int = -300

var isFall : bool = false

func _process(delta):
	update_animation()
	if not isFall and position.y > maxHeight:
		linear_velocity.y -= 10
	else:
		isFall = true

func update_animation():
	if linear_velocity.y <= 0:
		get_node("Sprite").frame_coords.y = 4
	else:
		get_node("Sprite").frame_coords.y = 2
```

#### Make `JumpingFish` Pass Throught Platform

Untuk membuat _node_ `JumpingFish` melewati _platform_ yang telah dibuat, pada atribut `collision_layer` dan `collision_mask` yang dimiliki oleh _node_ `CollisionObject2D`, update nilai layer dan mask menjadi 2 saja. Berdasarkan [dokumentasi](https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html#collision-layers-and-masks), `collision_layer` mendeskripsikan layer objek itu berada, sedangkan `collision_mask` mendeskripsikan layer apa yang akan dideteksi oleh objek tersebut. Implementasi ini dapat membuat _node_ `JumpingFish` mampu melewati platform karena berada di layer 1.

Namun implementasi ini masih belum cukup karena _node_ `JumpingFish` saat ini masih tidak dapat mendeteksi `Player` dikarenakan player masih berada di layer satu. Untuk itu, _node_ `Player` juga perlu di update nilai `collision_layer` menjadi 1 dan 2, sehingga `JumpingFish` dapat mendeteksi `Player` dan `Player` masih dapat _collide_ dengan platform.

#### queue_free upon back to position.y == 0

Terakhir, supaya game tidak menjadi ngelag karena _node_ `JumpingFish` tidak akan menghilang (`queue_free()`). _Conditional_ menghilang dari _node_ `FallingFish` terjadi ketika _node_ `FallingFish` menyentuh objek lain selain `Player`, dimana tidak akan pernah terjadi pada _node_ `JumpingFish`.

Untuk mengatasinya, ditambahkan _if condition_ untuk `queue_free()` ketika `position.y` dari `JumpingFish` kembali ke titik awalnya (atau kurang dari titik awalnya).

```
func _process(delta):
	update_animation()
	if not isFall and position.y > maxHeight:
		linear_velocity.y -= 10
	elif isFall and position.y >= 0:
		self.queue_free()
	else:
		isFall = true
```

### PopupFish
