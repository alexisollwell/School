'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"version.json": "539c900687f75e7d7a8e642a93a4fac8",
"index.html": "50ad50ba321bdf9f56e2ee353b8a69d8",
"/": "50ad50ba321bdf9f56e2ee353b8a69d8",
"main.dart.js": "fc4eec6a1366a193f1ab65e0bc49b06d",
"flutter.js": "c71a09214cb6f5f8996a531350400a9a",
"favicon.png": "81b550944f135df9910b1598f6ba62d7",
"icons/favicon-16x16.png": "81b550944f135df9910b1598f6ba62d7",
"icons/favicon.ico": "0d20b2d6b46fe45b657a064343c4d4c4",
"icons/Icon-192.png": "a850a52eb549513f301122a54aee9e89",
"icons/Icon-512-old.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "a850a52eb549513f301122a54aee9e89",
"icons/Icon-192-old.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192-old.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512-old.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-maskable-512.png": "a850a52eb549513f301122a54aee9e89",
"icons/Icon-512.png": "a850a52eb549513f301122a54aee9e89",
"icons/favicon-32x32.png": "3f9387a3acdab2845eb93fbed365c05f",
"manifest.json": "078ffa6eebb8050bef43b1447864b3ac",
"assets/AssetManifest.json": "fe6db1d4dec476fe88f44d4679b8ec35",
"assets/NOTICES": "b73f8cf9fbde74cd24e292212f9f5bed",
"assets/FontManifest.json": "5a32d4310a6f5d9a6b651e75ba0d7372",
"assets/AssetManifest.bin.json": "ed55473dd54b9273421358ac7300d114",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "aa1ec80f1b30a51d64c72f669c1326a7",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "5178af1d278432bec8fc830d50996d6f",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "b37ae0f14cbc958316fac4635383b6e8",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "26545c44d445d7f185733e8c4cc90555",
"assets/fonts/MaterialIcons-Regular.otf": "605c84f63550647f413c43d908965a1d",
"assets/assets/images/uxlogo.svg": "267c9029deb472a3ca596dca6ebda8d3",
"assets/assets/images/slider1.jpg": "28ea2b7c819ec14ccd32f0cb0708fe9b",
"assets/assets/images/slider3.jpg": "5dcc7710df3b92e0ff5d182c606f649a",
"assets/assets/images/slider2.jpg": "c55ee1e1d504a41c9e909646b9acd442",
"assets/assets/images/user.png": "f29521fe50ba733ab0db85c74240ece4",
"assets/assets/images/xochicalco.png": "d039c57c36ccbcd54cb3d960c8e2b2f3",
"assets/assets/images/bottom-img-withoutLetters.png": "fb43256c717db2bed3904674430b85fc",
"assets/assets/images/shopping-cart.jpeg": "b8bf83f47bf3d0f5b35c476e00984532",
"assets/assets/images/revenue.png": "d3658ae29d02cf4debd861c98e46fca8",
"assets/assets/images/profit.png": "ff129e079676eefbce484d90ce373428",
"assets/assets/images/xo.png": "815c0571a9384903efa56911b987fbcf",
"assets/assets/images/loadingLogo.png": "aa8f33a7d04233bfd70770543d345a8d",
"assets/assets/images/user-avatar2.png": "b62295bd6b8757d8eaa1b0edeee13db3",
"canvaskit/skwasm.js": "445e9e400085faead4493be2224d95aa",
"canvaskit/skwasm.js.symbols": "741d50ffba71f89345996b0aa8426af8",
"canvaskit/canvaskit.js.symbols": "38cba9233b92472a36ff011dc21c2c9f",
"canvaskit/skwasm.wasm": "e42815763c5d05bba43f9d0337fa7d84",
"canvaskit/chromium/canvaskit.js.symbols": "4525682ef039faeb11f24f37436dca06",
"canvaskit/chromium/canvaskit.js": "43787ac5098c648979c27c13c6f804c3",
"canvaskit/chromium/canvaskit.wasm": "f5934e694f12929ed56a671617acd254",
"canvaskit/canvaskit.js": "c86fbd9e7b17accae76e5ad116583dc4",
"canvaskit/canvaskit.wasm": "3d2a2d663e8c5111ac61a46367f751ac",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
