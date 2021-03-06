import 'dart:html';
import 'package:angular2/angular2.dart';
import 'dart:async';

/// Collapse component allows you to toggle content on your pages with a bit of JavaScript and some
/// classes. Flexible component that utilizes a handful of classes (from the **required transitions
/// component**(*not yet implemented*)) for easy toggle behavior.
///
/// Base specifications: [bootstrap 3](http://getbootstrap.com/javascript/#collapse)
/// or [bootstrap 4](http://v4-alpha.getbootstrap.com/components/collapse/)
///
/// [demo](http://luisvt.github.io/ng2_strap/#collapse)
@Directive(selector: '[bsCollapse]',
    host: const {
      '[class.collapse]' : '!collapsing',
      '[attr.aria-hidden]': '!expanded'
    })
class BsCollapseDirective implements OnInit {
  /// Constructs an collapsible component
  BsCollapseDirective(this.elementRef);

  /// Contains the element reference of this component
  ElementRef elementRef;

  /// provides the height style of the component in pixels
  @HostBinding('style.height')
  String height = '0';

  /// if `true` the component is shown
  @HostBinding('class.in')
  @HostBinding('attr.aria-expanded')
  bool expanded = true;

  /// provides the animation state
  @HostBinding('class.collapsing')
  bool collapsing = false;

  bool _bsCollapse = false;

  /// sets and fires the collapsed state of the component
  @Input() set bsCollapse(bool value) {
    _bsCollapse = value ?? false;
    if (_bsCollapse) {
      _hide();
    } else {
      _show();
    }
  }

  String get _scrollHeight => (elementRef.nativeElement as Element).scrollHeight.toString() + 'px';

  /// Emits the Collapse state of the component
  @Output() EventEmitter<bool> bsCollapseChange = new EventEmitter<bool>();

  /// Emits the collapsing state of the component
  @Output() EventEmitter<bool> collapsingChange = new EventEmitter<bool>();

  /// Initialize the [Collapse] [height] value
  ngOnInit() {
    height = _scrollHeight;
  }

  _hide() {
    if (!expanded && !collapsing) return;

    collapsingChange.emit(collapsing = true);
    new Future(() {
      height = '0';
      new Timer(const Duration(milliseconds: 350), () {
        expanded = !_bsCollapse;
        collapsingChange.emit(collapsing = false);
        bsCollapseChange.emit(!expanded);
      });
    });
  }

  _show() {
    if (expanded && !collapsing) return;

    collapsingChange.emit(collapsing = true);
    expanded = true;
    new Future(() {
      height = _scrollHeight;
      new Timer(const Duration(milliseconds: 350), () {
        collapsingChange.emit(collapsing = false);
        bsCollapseChange.emit(!expanded);
      });
    });
  }
}