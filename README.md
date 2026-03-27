# 离线翻译 APP · Offline Translator

> Flutter 3.27.4 + llma.cpp + GGUF 本地模型

## 自动构建

每次推送到 `master` 分支会自动触发 GitHub Actions 构建 APK。

**下载 APK：**
1. 打开 [Actions 页面](https://github.com/yanfyanqiu/offline_translator/actions)
2. 点击最新的 workflow run
3. 滚动到底部 Artifacts 区域
4. 下载 `offline-translator-debug-apk` 或 `offline-translator-release-apk`

## 三个模型

| 模型 | 文件 | 下载地址 |
|------|------|---------|
| ASR 语音识别 | whisper-small.gguf | [HuggingFace](https://huggingface.co/buckets/andyang/whisper-small) |
| MT 翻译 | HY-MT1.5-1.8B-q5_k_m.gguf | [HuggingFace](https://huggingface.co/buckets/andyang/q5) |
| TTS 语音合成 | neutts-air-Q4_0.gguf | [HuggingFace](https://huggingface.co/buckets/andyang/neutts-air-Q4_0) |

## 功能

- 🎤 **语音翻译**：按住说话，自动识别翻译播放
- 🔄 **同声传译**：实时双语翻译，A/B 声道输出
- 📝 **文本翻译**：输入文字翻译
- 📷 **拍照翻译**：相机取景 OCR 翻译
- 📚 **背单词**：自定义播放列表学习

## 本地开发

```bash
flutter pub get
flutter run -d <device-id>
```

## 目录结构

```
lib/
├── main.dart
├── core/        # 常量、主题、国际化
├── models/      # 数据模型
├── interfaces/  # 接口定义（供后端接入）
├── services/    # 模型加载、翻译流水线
├── blocs/       # BLoC 状态管理
├── ui/
│   ├── screens/ # 全部界面
│   └── widgets/ # 通用组件
└── utils/       # 音频录制/播放、下载器
```
