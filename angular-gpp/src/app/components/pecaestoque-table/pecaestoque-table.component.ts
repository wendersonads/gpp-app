import { ChangeDetectorRef, Component, OnInit, ViewChild } from '@angular/core';
import { Router } from '@angular/router';
import { LocalDataSource } from 'ng2-smart-table';
import { Table } from 'primeng/table';
import { PecaEstoqueService } from 'src/app/services/pecaestoque.service';
import { PecaEstoqueModel } from 'src/app/models/PecaEstoqueModel';
import { MessageService } from 'primeng/api';


@Component({
  selector: 'app-pecaestoque-table',
  templateUrl: './pecaestoque-table.component.html',
  styleUrls: ['./pecaestoque-table.component.css'],
  providers: [MessageService]
})
export class PecaEstoqueTableComponent implements OnInit {

  @ViewChild('dt2') dt2: Table | undefined;

  PecasEstoque: PecaEstoqueModel[] = [];
  pageTitle: string = 'Estoque';
  public source: LocalDataSource = new LocalDataSource(this.PecasEstoque);

  constructor(
    private pecaEstoqueService : PecaEstoqueService,
    private router: Router,
    private cdr: ChangeDetectorRef,
    private messageService: MessageService
  ) { }

  ngAfterViewInit() {
     console.log('dt2:', this.dt2);
  }

  ngOnInit(): void {
    this.list();
  }

  list(): void {
    this.pecaEstoqueService.list().subscribe(resp => {
      this.PecasEstoque = resp;
      this.source.load(resp);
    });
  }

  novo(): void {
    this.router.navigateByUrl('/pecaestoque/novo');
  }

  onCustomAction(event: any): void {
    const pecaEstoque: PecaEstoqueModel = event.data;
    console.log(event);
    this.router.navigate([`pecaestoque/${pecaEstoque.idPecaEstoque}`]);
  }

  editePecaEstoque(pecaEstoque: PecaEstoqueModel): void {
    this.router.navigateByUrl(`/pecaestoque/editar/${pecaEstoque.idPecaEstoque}`);
  }

  editPecaEstoque(id: number): void {
    this.router.navigate(['/pecaestoque/editar', id]);
  }

  deletePecaEstoque(id: number): void {
    this.pecaEstoqueService.delete(id).subscribe(() => {
      this.list();
      this.showMessage(`O estoque para peça ${id} foi deletado`);
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

  adicionarPecaEstoque(): void {
     this.router.navigateByUrl(`pecaestoque/:id`);
  }
}
