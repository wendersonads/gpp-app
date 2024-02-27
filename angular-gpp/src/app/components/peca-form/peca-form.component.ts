import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { PecaModel } from 'src/app/models/PecaModel';
import { PecaService } from '../../services/peca.service';
import { ActivatedRoute, Router } from '@angular/router';
import { ProdutoModel } from 'src/app/models/ProdutoModel';
import { ProdutoService } from 'src/app/services/produto.service';

@Component({
  selector: 'app-peca-form',
  templateUrl: './peca-form.component.html',
  styleUrls: ['./peca-form.component.css']
})
export class PecaFormComponent implements OnInit {

  displayDialog: boolean = true;
  produtos: ProdutoModel[] = [];
  filteredProdutos: ProdutoModel[] = [];
  selectedProduto: ProdutoModel | null = null;
  peca: PecaModel = new PecaModel();
  pageTitle: string = 'Novo';
  pecaForm: FormGroup;

  constructor(
    private pecaService: PecaService,
    private router: Router,
    private route: ActivatedRoute,
    private produtoService: ProdutoService,
    private formBuilder: FormBuilder
  ) {
    this.pecaForm = this.formBuilder.group({});
  }

  ngOnInit(): void {
    this.produtoService.list().subscribe(produtos => {
      this.produtos = produtos;
    });
    this.buildForm();
  }

  private buildForm(): void {
    this.pecaForm = this.formBuilder.group({
      numero: ['', [Validators.required, Validators.pattern('^[0-9]+$')]],
      codigoFabrica: ['', Validators.required],
      unidade: ['', [Validators.required, Validators.pattern('^[0-9]+$')]],
      descricao: ['', Validators.required],
      altura: ['', [Validators.required, Validators.pattern('^[0-9]+(\.[0-9]{1,2})?$')]],
      largura: ['', [Validators.required, Validators.pattern('^[0-9]+(\.[0-9]{1,2})?$')]],
      profundidade: ['', [Validators.required, Validators.pattern('^[0-9]+(\.[0-9]{1,2})?$')]],
      unidadeMedida: ['', Validators.required],
      volumes: ['', [Validators.required, Validators.pattern('^[0-9]+(\.[0-9]{1,2})?$')]],
      active: [false],
      custo: ['', [Validators.required, Validators.pattern('^[0-9]+(\.[0-9]{1,2})?$')]],
      cor: ['', Validators.required],
      material: ['', Validators.required],
      materialFabricacao: ['', Validators.required],
      produto: ['', Validators.required]
    });
  }

  public salvar(): void {
    if (this.pecaForm.invalid) {
      return;
    }

    const formValue = this.pecaForm.value;
    this.peca = { ...this.peca, ...formValue };
    this.peca.idFornecedor = this.selectedProduto?.fornecedor?.idFornecedor;

    this.pecaService.add(this.peca).subscribe(() => {
      this.peca = new PecaModel();
      this.router.navigateByUrl('/pecaList');
    });
  }

  public searchProdutos(event: any): void {
    this.filteredProdutos = this.produtos.filter(produto =>
      produto?.descricao?.toLowerCase().includes(event.query.toLowerCase())
    );

    this.selectedProduto = null;
  }

  cancelar(): void {
    this.router.navigateByUrl('/pecaList');
  }
}
