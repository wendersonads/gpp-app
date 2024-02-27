import { ChangeDetectorRef, Component, OnInit, ViewChild } from '@angular/core';
import { Router } from '@angular/router';
import { LocalDataSource } from 'ng2-smart-table';
import { Table } from 'primeng/table';
import { ProdutoService } from 'src/app/services/produto.service';
import { ProdutoModel } from 'src/app/models/ProdutoModel';
import { MessageService } from 'primeng/api';

@Component({
  selector: 'app-produto-table',
  templateUrl: './produto-table.component.html',
  styleUrls: ['./produto-table.component.css'],
  providers: [MessageService]
})
export class ProdutoTableComponent implements OnInit {

  @ViewChild('dt2') dt2: Table | undefined;

  produtos: ProdutoModel[] = [];
  pageTitle: string = 'Produto';
  public source: LocalDataSource = new LocalDataSource(this.produtos);

  constructor(
    private produtoService: ProdutoService,
    private router: Router,
    private cdr: ChangeDetectorRef,
    private messageService: MessageService
  ) { }

  ngAfterViewInit() {
    // console.log('dt2:', this.dt2);
  }

  ngOnInit(): void {
    this.list();
  }

  list(): void {
    this.produtoService.list().subscribe(resp => {
      this.produtos = resp;
      this.source.load(resp);
    });
  }

  novo(): void {
    this.router.navigateByUrl('/produto/novo');
  }

  onCustomAction(event: any): void {
    const produto: ProdutoModel = event.data;
    console.log(event);
    this.router.navigate([`produto/${produto.idProduto}`]);
  }

  editeProduto(produto: ProdutoModel): void {
    this.router.navigateByUrl(`/produto/editar/${produto.idProduto}`);
  }

  editProduto(id: number): void {
    this.router.navigate(['/produto/editar', id]);
  }

  deleteProduto(id: number): void {
    this.produtoService.delete(id).subscribe(() => {
      this.list();
      this.showMessage(`O produto ${id} foi deletado`);
    });
  }

  showMessage(message: string): void {
    this.messageService.add({
      severity: 'success',
      summary: '',
      detail: message,
      life: 10000
    });
  }

  onSearch(event: Event): void {
    const value = (event.target as HTMLInputElement).value;
    console.log('Search value:', value);
    this.dt2?.filterGlobal(value, 'contains');
    console.log('Filtered data:', this.dt2?.value);
    this.cdr.detectChanges();
    console.log('test data:', this.dt2?.value);
  }

  adicionarProduto(): void {
    this.router.navigateByUrl(`produto/:id`);
  }
}
