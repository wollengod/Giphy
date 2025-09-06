import 'package:flutter/material.dart';
import 'api_service.dart';


class GifScreen extends StatefulWidget {
  const GifScreen({super.key});

  @override
  State<GifScreen> createState() => _GifScreenState();
}

class _GifScreenState extends State<GifScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<dynamic> gifs = [];
  int offset = 0;
  bool isLoading = false;
  String query = "";

  @override
  void initState() {
    super.initState();
    _loadGifs();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _loadMore();
      }
    });
  }

  Future<void> _loadGifs() async {
    setState(() => isLoading = true);
    List<dynamic> newGifs;
    if (query.isEmpty) {
      newGifs = await GiphyApi.fetchTrending(offset);
    } else {
      newGifs = await GiphyApi.searchGifs(query, offset);
    }
    setState(() {
      gifs.addAll(newGifs);
      isLoading = false;
    });
  }

  void _loadMore() {
    setState(() => offset += 20);
    _loadGifs();
  }

  void _onSearchChanged(String value) {
    setState(() {
      query = value;
      offset = 0;
      gifs.clear();
    });
    _loadGifs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🔥 Giphy Search")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: "Search GIFs...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  query.isEmpty
                      ? "Trending GIFs 🔥"
                      : "Results for: $query",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              padding: const EdgeInsets.all(8),
              itemCount: gifs.length,
              itemBuilder: (context, index) {
                final gif = gifs[index];
                // final url = gif["images"]["fixed_height"]["url"];
                final url = gif["images"]["fixed_width_small"]["url"];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(url, fit: BoxFit.cover),
                );
              },
            ),
          ),
          if (isLoading) const Padding(
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
