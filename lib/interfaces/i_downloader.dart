// interfaces/i_downloader.dart
enum DownloadState { pending, downloading, paused, completed, error }
class DownloadTask {
  final String taskId, url, savePath;
  final DownloadState state;
  final int totalBytes, downloadedBytes;
  final double progress;
  const DownloadTask({required this.taskId,required this.url,required this.savePath,required this.state,this.totalBytes=0,this.downloadedBytes=0,this.progress=0.0});
}
class DownloadItem {
  final String url, savePath;
  const DownloadItem({required this.url, required this.savePath});
}
abstract class IDownloader {
  Future<void> download({required String url, required String savePath, void Function(double)? onProgress, void Function(int)? onSpeed, void Function()? onComplete, void Function(String)? onError, int? resumeFrom});
  Future<void> pause(String taskId);
  Future<void> resume(String taskId);
  Future<void> cancel(String taskId);
  DownloadTask? getTask(String taskId);
  Future<int> getDownloadedBytes(String savePath);
  Future<void> downloadBatch(List<DownloadItem> items, {int maxConcurrency=2, void Function(String,double)? onEachProgress, void Function(String)? onEachComplete, void Function(String,String)? onEachError});
}
