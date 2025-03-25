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
    ];
  private dataMores: string[] =
    ['商汤科技宣布其 Sensechat 手机 App 及网页版现已向香港用户免费开放。该服务基于商汤今年5月推出的“商量多模态大模型粤语版”，支持用户使用粤语进行文字或语音输入，进行聊天、搜索、生成图片和写文案等操作。',
      'ControlNet作者张吕敏的新项目Paints-Undo在GitHub上迅速走红，发布不到24小时就获得了600多颗星。该项目能够将任意一张图像生成一个25秒的绘画过程视频，展示从线稿到填色及细节调整的全过程。',
      '近期，马斯克麾下人工智能公司xAI与甲骨文之间的协议扩展谈判宣告破裂。原协议中，xAI计划从甲骨文租赁专用的英伟达人工智能芯片。但据知情人士透露，xAI现已决定自主采购芯片，以构建其数据中心基础设施。',
      '支付宝推出了其医疗大模型，该模型在中英文医疗考试和基准测试中表现优异，超过了GPT-4的水准，并在中文医疗LLM评测榜单中名列前茅。该模型具备多模态能力，能够处理音频、视频、图像和文本数据，识别报告、药品和毛发等图像的准确率超过90%。',
      'DeepMind团队提出了一种名为JEST的新数据筛选方法，显著提升了AI训练效率。JEST通过联合选择最佳数据批次进行训练，将AI训练时间减少13倍，算力需求降低90%。',
      'X 社交平台正在开发多项基于 xAI Grok 模型的新功能，以提升 X Premium 订阅用户的使用体验。这些功能包括一个类似生成式 AI 聊天机器人的 Grok 侧面板，用户可以在使用平台时与Grok机器人交流。',
      '谷歌 DeepMind 首席执行官戴密斯・哈萨比斯在“2024 年英国未来会议”上表示，当前人工智能（AI）的综合智力水平尚未达到猫的水平，但在游戏等特定领域表现优于人类。',
      'AI 初创公司 Anthropic 的首席执行官 Dario Amodei 在接受采访时透露，当前像 GPT-4o 这样的模型训练成本约为 1 亿美元，而未来开发的 AI 大模型训练成本可能高达 10 亿美元，并预测未来三年内这一成本将上升至 100 亿美元甚至 1000 亿美元。',
      'LLM-based AI Agent是在类ChatGPT的LLM基础上，进行planning、reasoning、decision、tool usage等技术加成，让LLM不仅能够进行通用问答，还能真正和现实世界中的实体进行交互，达到改变世界的目的。',
      'Google Trends 是一个由谷歌提供的在线服务，用于显示各种搜索查询在特定时间段和地区内的流行度。它不仅可以展示单个搜索词或短语的趋势，还可以比较多个词汇或短语的相对流行度。',
      '秘塔搜索，由上海秘塔网络科技在2024年初推出，背后自研大模型MetaLLM（基于Transformer底层架构投入中文语料训练），支持多轮对话式搜索，被誉为中国版Perplexity。',
      'Kimi大语言模型是由国内AI创业公司月之暗面科技有限公司（Moonshot AI）开发的一款基于深度学习和自然语言处理技术的人工智能模型。该模型的设计灵感来源于人类大脑的工作原理，通过模拟神经网络的方式来实现智能决策和学习能力。',
      'Claude 3.5 Sonnet是Anthropic 6月20最新出的目前最强的AI大语言模型，据说比gpt4o具体更强的推理能力，实际使用感受确实会更好一点。',
      'PaLM-E模型采用了先进的多模态AIGC技术，它可以结合图像、声音、触觉等多个传感器信号来进行深度学习，并从中提取出关键特征。同时，PaLM-E还能够将文本输入转换为语义表示，与感知信息相结合进行综合判断和决策。',
      '量子计算领先企业IBM于2023年12月公布全球首个可扩展量子计算系统Quantum System Two，引入模块化架构和计算机集群设计，可让系统容纳10000个量子比特。模块化量子计算集群的出现，预示可复制性更强、扩展性更好的量子计算机发展新路径',
      '德国维尔茨堡大学经济学家Alicia von Schenk及其团队研发了一款基于人工智能的测谎工具，准确率达67%，显著高于人类的50%。实验显示，使用该工具的人在识别谎言方面有所提升，但也导致更多人被怀疑说谎。',
      '“数字甲骨共创中心”于7月5日开源了全球最大的甲骨文多模态数据集，包含一万片甲骨的拓片、摹本及相关数据。该数据集将助力研究者开发甲骨文检测、识别、摹本生成、字形匹配和释读等算法，推动甲骨文研究的智能化。',
      '2024年世界人工智能大会（WAIC 2024）上，中国首款全尺寸通用人形机器人“青龙”正式发布。“青龙”由人形机器人（上海）有限公司自研，身高185cm，体重80kg，拥有43个主动自由度和400N・m的关节峰值扭矩，算力支持400TOPS。',
      'ElevenLabs是一家以语音克隆、 文本转语音和语音转语音模型而闻名的人工智能语音初创公司，最新在其产品组合中添加了另一种工具：AI语音分离工具（AI Voice Isolator）。',
      'Meta公司于7月2日发布了一项名为Meta 3D Gen（3DGen）的全新AI模型，能够在1分钟内基于用户输入的提示词生成高质量的3D内容。该模型生成的3D内容具备高分辨率纹理和材质贴图，并支持基于物理的渲染（PBR）。',
      'Suno 是一款人工智能音乐和歌曲生成软件，现已上架苹果 App Store（国区暂未上架）。用户可以通过文字描述或录制音频创建自己的音乐，生成时长为 4 分钟或 2 分钟的歌曲。免费用户每日可获得 50 个积分，每次生成歌曲消耗 5 积分，每日可免费生成 10 首歌曲。',
      '根据 The Information 最新报道，Runway 正在与 General Atlantic 洽谈新一轮 4.5 亿美元融资，估值达 40 亿美元。2023 年 6 月，Runway 曾从包括 Google、Nvidia 和 Salesforce Ventures 在内的投资者那里筹集了 1.41 亿美元，当时的估值为 15 亿美元。',
      '据报道，作为上个月宣布的里程碑式协议的一部分，苹果公司将获得OpenAI董事会观察员职位，这进一步加强了两家公司之间的联系。据知情人士透露，苹果应用商店（App Store）负责人、前营销主管Phil Schiller被选中担任这一职位。',
      '港大和字节跳动的研究团队推出了基于自回归模型Llama的图像生成方法LlamaGen，并已开源。该模型在ImageNet测试基准上表现优于主流的扩散模型如LDM和DiT，证明了自回归模型在图像生成领域的竞争力。',
      '微软创始人比尔・盖茨在播客节目 Next Big Idea Club 的采访中讨论了人工智能（AI）和超级智能的未来发展。他认为未来每个人可能会拥有一个“AI 顾问”，其硬件形态并不重要，关键在于其功能。',
      'Odyssey团队推出了具备好莱坞级视觉效果的AI特效系统，号称“新时代皮克斯”。该系统能够生成高质量的山脉、平原、植被、海洋等场景，并实现对视觉叙事核心层的完全控制，突破了现有视频AI的可控性障碍。',
      '富国银行预测，2023年AI用电需求为8 TWh，到2030年将激增至652 TWh，增长8050%。AI用电主要用于训练AI模型，预计2026年达到40 TWh，2030年达到402 TWh。此外，AI推理耗电量将在21世纪20年代末快速增长。',
      '为科研人员、高校师生和职场人士研发的大模型应用产品心流正式上线，定位为 AI 搜索助手，提供智能搜索、知识问答、智能阅读、辅助创作等能力。心流支持搜索问答和阅读分析，网页版已上线，小程序和 APP 版即将推出。',
      '亚马逊网络服务（AWS）宣布推出第四代 Graviton 处理器——Graviton4 芯片，Graviton4 芯片在性能和效率上大幅提升，计算能力、内存和内存带宽等方面均有显著进步，提供了更高性价比。半导体行业价值增长，需求提升，超大规模企业纷纷开发定制芯片。',
      '微软将为 Word 增加新的 AI 功能，让 Microsoft Copilot 撰写出更具个性化的内容。微软将增加 Personalization 配置文件，读取用户的偏好、兴趣和其他信息，为用户提供更加个性化的体验。这项功能可以模仿用户的口吻和经历，撰写出更符合用户风格的内容。',
      '小米开启米家 App 智能感知体验计划招募。该内测应用将通过大模型能力，基于小米设备互联的数据基础，利用多模态的设备信息，实时感知用户关键场景并提供服务。智能感知服务支持更好地识别用户离家、回家时间，更精准地识别用户睡着、醒来时间，以及准确辨别家中是否有人。',
      '电视剧《长相思 2》开播，腾讯大模型应用“腾讯元宝”携手腾讯视频，共同推出了《长相思》的角色 AI ，若想体验诸如角色对话、剧情互动、角色 COS 等创新玩法，在腾讯元宝 App 的首页，或者腾讯视频的《长相思》专题页进行操作，即可轻松实现。',
      '由成龙、娜扎主演的《神话》电影续集《传说》正式上映，这是全球首部由 AI 塑造的数字明星主演的院线电影，其中用 AI 技术复原的 27 岁成龙出演量达 70%以上。从豆瓣网友评价来看，对这部影片的看法两极分化，有人认为剧情差，也有人称赞成龙表现出色，甚至称其为近十年最好的成龙电影。',
      'OpenAI 的 CEO 山姆·奥特曼与赫芬顿邮报创始人阿里安娜·赫芬顿共同创立「Thrive AI Health」公司，将利用 AI 技术提升健康和生活质量。 致力于打造“AI 健康教练”，CEO 由 DeCarlos Love 担任。',
      '国际数据公司 IDC 发布《中国智算服务市场（2023 下半年）跟踪》报告，2023 下半年中国智算服务市场整体规模达 114.1 亿元人民币，同比增长 85.8%。智算服务包括以 GPU 等为主的基础设施服务，分智算集成服务、AI IaaS（又细分为 GenAI IaaS 和 Non-GenAI IaaS）。',
      '腾讯智影小程序上线智影 AI 视频功能，一键生成风格化视频，有日漫风格可选，限时免费。在原视频的基础上进行风格化处理，可以提升视频美感、增强趣味性、提升传播力。只需导入视频并一键“变身”，就能快速生成风格化视频（支持 10s 视频），智影 AI 提供了多种模板。',
      '中国电信人工智能科技有限公司和中国电信人工智能研究院（TeleAI）发布星辰大模型・软件工厂的产品，称其为国内首款破局性 AI 开发工具。该工具利用多模态大模型技术，能自动生成前后端代码、自主测试和纠错，形成全自动流水线，用户简单写下产品文档即可生成代码并一键部署上线。',
      'Meta AI将推出 MobileLLM 的紧凑型AI模型，尽管参数较少，但与其他人工智能模型一样有效，在计算能力较弱的智能手机上也能发挥作用。MobileLLM 的研究团队来自 Meta Reality Labs、PyTorch 和 Meta AI study的研究人员，他们专注于优化参数少于十亿的模型。',
      '市场调查机构 Gartner 发布调查报告，64% 的受访客户不希望客服使用 AI，53% 客户表示，如果发现某家公司客服使用 AI，会考虑转向竞争对手。客户认为引入 AI 后，联系人工客服更加困难，而且担心AI 提供答案错误。',
      '月之暗面官宣上线 Kimi 浏览器插件，该插件支持轻量搜索，适用于多种场景。已上线“点问笔”和“总结器”两项功能，点问笔在用户划选文字后自动出现，支持上下文理解；总结器常驻浏览器右下角（位置可自定义），支持总结全文和提炼长文重点。',
      '在 2024 世界人工智能大会上，国内多家产学研机构联合发布两份白皮书《隐私计算产品通用安全分级》和《个人信息匿名化制度:技术与法律（2024）》。推动数据要素可信流通需技术研发与标准制定配合，要解决通用安全分级等问题。',
      '人们在分辨真假信息上挑战增多，传统测谎手段准确性存疑，人工智能测谎工具被认为或可提高识别谎言准确率。德国维尔茨堡大学经济学家 Alicia von Schenk 及其团队研发的人工智能测谎工具准确率高于人类，实验中使用该工具的人识别谎言能力提升，但也导致更多人被怀疑说谎。',
    ]
  @State data: string[] = this.dataStrings;
  @State dataMore: string[] = this.dataMores
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
    RelativeContainer() {
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
      .id("title")

      // 轮播图
      Swiper() {
        Image($r("app.media.ai_chat_bot"))
          .width('100%')
        Image($r("app.media.scsx_gpt"))
          .width('100%')
        Image($r("app.media.new_free"))
          .width('100%')
      }
      .alignRules({ top: { anchor: "title", align: VerticalAlign.Bottom } })
      .autoPlay(true)
      .indicator( // 设置圆点导航点样式
        new DotIndicator()//写一篇500字的关于实习的日记
          .itemWidth(8)
          .itemHeight(8)
          .selectedItemWidth(8)
          .selectedItemHeight(8)
          .color(Color.White)
          .selectedColor('sys.color.brand')
      )
      .margin(5)
      .id("Swiper")


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
              url: 'pages/Index',
              params: {
                current: 0
              }
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
              url: 'pages/Index',
              params: {
                current: 1
              }
            });
          })

          Text('翻译')
        }//你好
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
              url: 'pages/Index',
              params: {
                current: 2
              }
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
      .alignRules({ top: { anchor: "Swiper", align: VerticalAlign.Bottom } })

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
                this.dataStrings = []
                for (let index = 0; index < 6; index++) {
                  let randomNumber: number = Math.floor(Math.random() * this.dataMores.length);
                  this.dataStrings.push(this.dataMores[randomNumber])
                }
                this.data = this.dataStrings

              }, 1000);
            });
          },
          // 可选项，上拉加载更多回调
          onLoadMore: () => {
            return new Promise<string>((resolve, reject) => {
              // 模拟网络请求操作，请求网络2秒后得到数据，通知组件，变更列表数据
              setTimeout(() => {
                resolve('');
                for (let index = 0; index < 3; index++) {
                  let randomNumber: number = Math.floor(Math.random() * this.dataMores.length);
                  this.data.push(this.dataMores[randomNumber])
                }
              }, 500);
            });
          },
          customLoad: null,
          customRefresh: null,
        })
          .margin('2%')
      }.alignRules({ bottom: { anchor: "__container__", align: VerticalAlign.Bottom } }).height("70%")

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
    //请写一个500字的关于生产实习的日记
    //
  }
}