import { PullToRefresh } from '@ohos/pulltorefresh';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct Main {
  @State refreshText: string = '';
  @State targetIndex: number = 0
  private dataStrings: string[] =
    ['OpenAI CEO Sam Altman 与AI医疗健康巨头Thrive Global的CEO阿里安娜·赫芬顿（Arianna Huffington）一起在《时代》杂志上发表了一篇文章，正式宣布了Thrive AI Health公司的成立,目标是打造一个个性化“AI健康教练”。',
      '复旦大学教授、MOSS大模型项目负责人邱锡鹏认为，当前，大语言模型还存在很多不足。比如在落地阶段，大语言模型的会遇到难以解决的“幻觉问题”。邱锡鹏将大模型的未来趋势和发展方向，总结为观察世界、产生动作，并走向“世界模型”。',
      '阿里云通义千问近日开源了两款语音基座模型：SenseVoice和CosyVoice。SenseVoice专注于高精度多语言语音识别、情感辨识和音频事件检测，支持超过50种语言，识别效果优于Whisper模型。',
      '6月，IEEE TSE期刊发表了一篇关于ChatGPT在代码生成任务中的表现评估的论文，使用LeetCode题库作为数据集。研究发现，ChatGPT生成代码的成功率从0.66%到89%不等，取决于任务难度和编程语言。',
      '诈骗团伙开始利用AI工具Lenny实施诈骗，通过自动播放语音信息延长通话时间并提高成功率。为应对这一威胁，电信公司部署了数百个AI聊天机器人，其中包括名为Ibrahim的机器人，旨在“用魔法打败魔法”，帮助用户免受诈骗电话侵扰。',
      'Odyssey团队推出了具备好莱坞级视觉效果的AI特效系统，号称“新时代皮克斯”。该系统能够生成高质量的山脉、平原、植被、海洋等场景，并实现对视觉叙事核心层的完全控制，突破了现有视频AI的可控性障碍。',
      '富国银行预测，2023年AI用电需求为8 TWh，到2030年将激增至652 TWh，增长8050%。AI用电主要用于训练AI模型，预计2026年达到40 TWh，2030年达到402 TWh。此外，AI推理耗电量将在21世纪20年代末快速增长。',
      '商汤科技宣布其 Sensechat 手机 App 及网页版现已向香港用户免费开放。该服务基于商汤今年5月推出的“商量多模态大模型粤语版”，支持用户使用粤语进行文字或语音输入，进行聊天、搜索、生成图片和写文案等操作。',
      'ControlNet作者张吕敏的新项目Paints-Undo在GitHub上迅速走红，发布不到24小时就获得了600多颗星。该项目能够将任意一张图像生成一个25秒的绘画过程视频，展示从线稿到填色及细节调整的全过程。',
      '近期，马斯克麾下人工智能公司xAI与甲骨文之间的协议扩展谈判宣告破裂。原协议中，xAI计划从甲骨文租赁专用的英伟达人工智能芯片。但据知情人士透露，xAI现已决定自主采购芯片，以构建其数据中心基础设施。',
      '支付宝推出了其医疗大模型，该模型在中英文医疗考试和基准测试中表现优异，超过了GPT-4的水准，并在中文医疗LLM评测榜单中名列前茅。该模型具备多模态能力，能够处理音频、视频、图像和文本数据，识别报告、药品和毛发等图像的准确率超过90%。',
      'DeepMind团队提出了一种名为JEST的新数据筛选方法，显著提升了AI训练效率。JEST通过联合选择最佳数据批次进行训练，将AI训练时间减少13倍，算力需求降低90%。',
      'X 社交平台正在开发多项基于 xAI Grok 模型的新功能，以提升 X Premium 订阅用户的使用体验。这些功能包括一个类似生成式 AI 聊天机器人的 Grok 侧面板，用户可以在使用平台时与Grok机器人交流。',
      '谷歌 DeepMind 首席执行官戴密斯・哈萨比斯在“2024 年英国未来会议”上表示，当前人工智能（AI）的综合智力水平尚未达到猫的水平，但在游戏等特定领域表现优于人类。',
      'AI 初创公司 Anthropic 的首席执行官 Dario Amodei 在接受采访时透露，当前像 GPT-4o 这样的模型训练成本约为 1 亿美元，而未来开发的 AI 大模型训练成本可能高达 10 亿美元，并预测未来三年内这一成本将上升至 100 亿美元甚至 1000 亿美元。',

    ];
  private dataDetails: string[] =
    ['LLM-based AI Agent是在类ChatGPT的LLM基础上，进行planning、reasoning、decision、tool usage等技术加成，让LLM不仅能够进行通用问答，还能真正和现实世界中的实体进行交互，达到改变世界的目的。',
      'Google Trends 是一个由谷歌提供的在线服务，用于显示各种搜索查询在特定时间段和地区内的流行度。它不仅可以展示单个搜索词或短语的趋势，还可以比较多个词汇或短语的相对流行度。',
      '秘塔搜索，由上海秘塔网络科技在2024年初推出，背后自研大模型MetaLLM（基于Transformer底层架构投入中文语料训练），支持多轮对话式搜索，被誉为中国版Perplexity。',
      'Kimi大语言模型是由国内AI创业公司月之暗面科技有限公司（Moonshot AI）开发的一款基于深度学习和自然语言处理技术的人工智能模型。该模型的设计灵感来源于人类大脑的工作原理，通过模拟神经网络的方式来实现智能决策和学习能力。',
      'Claude 3.5 Sonnet是Anthropic 6月20最新出的目前最强的AI大语言模型，据说比gpt4o具体更强的推理能力，实际使用感受确实会更好一点。',
      'PaLM-E模型采用了先进的多模态AIGC技术，它可以结合图像、声音、触觉等多个传感器信号来进行深度学习，并从中提取出关键特征。同时，PaLM-E还能够将文本输入转换为语义表示，与感知信息相结合进行综合判断和决策。',
      '量子计算领先企业IBM于2023年12月公布全球首个可扩展量子计算系统Quantum System Two，引入模块化架构和计算机集群设计，可让系统容纳10000个量子比特。模块化量子计算集群的出现，预示可复制性更强、扩展性更好的量子计算机发展新路径',
      '德国维尔茨堡大学经济学家Alicia von Schenk及其团队研发了一款基于人工智能的测谎工具，准确率达67%，显著高于人类的50%。实验显示，使用该工具的人在识别谎言方面有所提升，但也导致更多人被怀疑说谎。',
      '“数字甲骨共创中心”于7月5日开源了全球最大的甲骨文多模态数据集，包含一万片甲骨的拓片、摹本及相关数据。该数据集将助力研究者开发甲骨文检测、识别、摹本生成、字形匹配和释读等算法，推动甲骨文研究的智能化。',
      '2024年世界人工智能大会（WAIC 2024）上，中国首款全尺寸通用人形机器人“青龙”正式发布。“青龙”由人形机器人（上海）有限公司自研，身高185cm，体重80kg，拥有43个主动自由度和400N・m的关节峰值扭矩，算力支持400TOPS。',
      'ElevenLabs是一家以语音克隆、 文本转语音和语音转语音模型而闻名的人工智能语音初创公司，最新在其产品组合中添加了另一种工具：AI语音分离工具（AI Voice Isolator）。'
    ]
  @State data: string[] = this.dataStrings;
  @State dataDetail: string[] = this.dataDetails
  // 需绑定列表或宫格组件
  private scroller: Scroller = new Scroller();

  @Builder
  mainBuilder() {
    Column() {
    }
    // 设置Column的宽高为100%，顶部边框，内容居中对齐
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
    .border({ width: { top: 1 }, color: '#eee' })
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Column() {
      // 标题
      Row() {
        Text('欢迎使用scsxGPT')
          .fontColor(Color.White)
          .fontSize(20)
          .fontFamily('dx')
          .padding(10)
          .height('100%')
      }
      .width('100%')
      .height(70)
      .backgroundColor($r('sys.color.brand'))

      // 轮播图
      Swiper() {
        Image($r("app.media.ai_chat_bot"))
          .width('100%')
        Image($r("app.media.scsx_gpt"))
          .width('100%')
        Image($r("app.media.new_free"))
          .width('100%')
      }
      .autoPlay(true)
      .indicator( // 设置圆点导航点样式
        new DotIndicator()
          .itemWidth(8)
          .itemHeight(8)
          .selectedItemWidth(8)
          .selectedItemHeight(8)
          .color(Color.White)
          .selectedColor('sys.color.brand')
      )
      .margin(5)

      // 功能按钮
      Row() {
        Column() {
          Button() {
            Image($r("app.media.chat"))
          }
          .type(ButtonType.Capsule)
          .backgroundColor($r('sys.color.comp_background_list_card'))
          .onClick(() => {
            router.pushUrl({
              url: 'pages/Index'
            });
          })

          Text('聊天')
        }
        .margin('10%')
        .width('10%')
        .height('40%')

        Column() {
          Button() {
            Image($r("app.media.translate"))
          }
          .type(ButtonType.Capsule)
          .backgroundColor($r('sys.color.comp_background_list_card'))
          .onClick(() => {
            router.pushUrl({
              url: 'pages/Index'
            });
          })

          Text('翻译')
        }
        .margin('10%')
        .width('10%')
        .height('40%')

        Column() {
          Button() {
            Image($r("app.media.myself"))
          }
          .type(ButtonType.Capsule)
          .backgroundColor($r('sys.color.comp_background_list_card'))
          .onClick(() => {
            router.pushUrl({
              url: 'pages/Index'
            });
          })

          Text('我的')
        }
        .margin('10%')
        .width('10%')
        .height('40%')

      }
      .margin(5)
      .height(70)

      // 资讯栏
      Column() {
        Row() {
          Text('今日AI资讯')
            .fontSize(20)
            .fontFamily('dx')
            .padding(10)
            .height('100%')
        }
        .width('100%')
        .height(70)

        PullToRefresh({
          // 必传项，列表组件所绑定的数据
          data: $data,
          // 必传项，需绑定传入主体布局内的列表或宫格组件
          scroller: this.scroller,
          // 必传项，自定义主体布局，内部有列表或宫格组件
          customList: () => {
            // 一个用@Builder修饰过的UI方法
            this.getListView();
          },
          // 可选项，下拉刷新回调
          onRefresh: () => {
            return new Promise<string>((resolve, reject) => {
              // 模拟网络请求操作，请求网络2秒后得到数据，通知组件，变更列表数据
              setTimeout(() => {
                resolve('刷新成功');
                this.data = this.dataDetails;
              }, 2000);
            });
          },
          // 可选项，上拉加载更多回调
          onLoadMore: () => {
            return new Promise<string>((resolve, reject) => {
              // 模拟网络请求操作，请求网络2秒后得到数据，通知组件，变更列表数据
              setTimeout(() => {
                resolve('');
                // this.data.push("增加的条目" + this.data.length);
                this.data.push(this.data[0])
              }, 2000);
            });
          },
          customLoad: null,
          customRefresh: null,
        })
          .margin('2%')
      }

    }
    .backgroundColor('#F1F3F5')

  }

  @Builder
  private getListView() {
    List({ space: 20, scroller: this.scroller }) {
      ForEach(this.data, (item: string) => {
        ListItem() {
          Row() {
            Text(item)
              .width('100%')
              .height('90%')
              .fontSize(16)
              .textAlign(TextAlign.Start)
              .backgroundColor(Color.White)
              .padding('5%')
          }.height(140)

        }
      })
    }
    .backgroundColor(Color.White)
    .divider({ strokeWidth: 1, color: 0x222222 })
    .edgeEffect(EdgeEffect.None) // 必须设置列表为滑动到边缘无效果
  }
}