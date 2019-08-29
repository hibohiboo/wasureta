export class PanelService {
  public open(): HTMLElement {
    const node = document.getElementById('main-content');
    if (node) { return node; }
    const newNode = document.createElement('div');
    newNode.id = 'main-content';
    document.getElementsByTagName('body')[0].appendChild(newNode)
    return newNode;
  }
}